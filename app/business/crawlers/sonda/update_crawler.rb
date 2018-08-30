module Crawlers
  module Sonda
    class UpdateCrawler < Crawlers::ApplicationCrawler
      SONDA_PRODUCTS = Product.where(market_name: 'sonda')

      class << self
        def execute
          update_sonda_products
        end

        private

        def update_sonda_products
          SONDA_PRODUCTS.each do |product_model|
            begin
              product_html = Nokogiri::HTML(open(product_model.url))

              # Check if product availability in database
              # is the same as the real stock
              # if not, update availability
              # and jump to the next product
              if toggle_availability?(product_model.availability, product_html.css('.noestoque'))
                puts "TOGGLE AVAILABILITY: #{product_model.name} (#{product_model.market.name}):(#{product_html.css('.noestoque').empty?})"

                # if .css('.noestoque') is empty, the product is in stock
                product_model.update(availability: !product_model.availability)

                # Dont update the price if availability is false
                # (dont use product_model.availability, because it may not have been reloaded yet)
                next unless product_html.css('.noestoque').empty?
              end

              # Update title
              update_price(product_model, product_html)

              # Update price
              update_price(product_model, product_html)
            rescue
              # TODO: Implement availability attribute
              # NOTE: THERE IS NOT YET A WAY TO CHECK
              # THE PRODUCT AVAILABILITY AT sonda
              puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
            end
          end
        end

        # If current_availability is empty, the product is in stock
        # If current_availability is not empty, the product is not in stock
        def toggle_availability?(product_availability, current_availability)
          product_availability != current_availability.empty?
        end

        # check if price changed
        # do nothing if it did not
        def update_price(product_model, product_html)
          price = product_html.css('.price').text
                              .gsub('R$', '').gsub(',', '.')
                              .strip.to_f

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
        def update_title(product_model, product_html)
          product_name = product_html.css('h3.product--title_in').text.strip
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
