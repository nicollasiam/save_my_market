module Crawlers
  module Extra
    class UpdateCrawler < Crawlers::ApplicationCrawler
      EXTRA_PRODUCTS = Product.where(market_name: 'extra')

      EXTRA_PRODUCT_API_BASE = 'https://api.gpa.digital/ex/products/'
      EXTRA_PRODUCT_API_OPTIONS = '?storeId=241&isClienteMais=false'

      class << self
        def execute
          update_extra_products
        end

        private

        def update_extra_products
          EXTRA_PRODUCTS.each do |product_model|
            begin
              product_id = product_model.url.split('/')[-2]

              product_hash = JSON.parse(Nokogiri::HTML(open("#{EXTRA_PRODUCT_API_BASE}#{product_id}#{EXTRA_PRODUCT_API_OPTIONS}")))

              # Check if product current stock
              # is the save in database.
              # update availability
              # and jump to the next product if not
              if toggle_availability?(product_model.availability, product_hash['content']['stock'])
                puts "TOGGLE AVAILABILITY: #{product_model.name} (#{product_model.market.name})"
                product_model.update(availability: !product_model.availability)

                # Dont update the price if availability is false
                # (dont use product_model.availability, because it may not have been reloaded yet)
                next unless product_hash['content']['stock']
              end

              # Update title
              update_title(product_model, product_hash)

              # Update price
              update_price(product_model, product_hash)
            rescue
              puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
            end
          end
        end

        def toggle_availability?(product_availability, current_availability)
          product_availability != current_availability
        end

        # check if price changed
        # do nothing if it did not
        def update_price(product_model, product_hash)
          price = product_hash['content']['currentPrice'].to_f.round(2)

          if product_model.price != price
            # if it changed, create a new price history and add it to the product
            new_price = PriceHistory.create(old_price: product_model.price,
                                            current_price: price,
                                            product: product_model)

            product_model.update(price: price)
            puts "PREÇO ATUALIZADO. #{product_model.name}: #{product_model.price_histories.order(:created_at).last.old_price} -> #{product_model.price_histories.order(:created_at).last.current_price}"
          end
        end

        # Update title
        def update_title(product_model, product_hash)
          product_name = product_hash['content']['name'].strip
          # Fix product name if it has wrong encoding
          # So it is not updated incorrectly
          product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

          if product_model.name != product_name
            puts "NOME ATUALIZADO. #{product_model.name} -> #{product_name}"

            product_model.update(name: product_name)
          end
        end
      end
    end
  end
end
