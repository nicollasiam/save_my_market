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

              price = product_hash['content']['currentPrice'].to_f.round(2)

              # Check if product current stock
              # is the save in database.
              # update availability
              # and jump to the next product if not
              # if toggle_availability?(product_model.availability, product_hash['content']['stock'])
              #   puts "PRODUTO INDISPONÍVEL: #{product_model.name} (#{product_model.market.name})"
              #   product_model.update(availability: product_hash['content']['stock'])
              #   next
              # end

              # check if price changed
              # do nothing if it did not
              if product_model.price != price
                # if it changed, create a new price history and add it to the product
                new_price = PriceHistory.create(old_price: product_model.price,
                                                current_price: price,
                                                product: product_model)

                product_model.update(price: price)
                puts "PRODUTO ATUALIZADO. #{product_model.name}: #{product_model.price_histories.order(:created_at).last.old_price} -> #{product_model.price_histories.order(:created_at).last.current_price}"
              end
            rescue
              puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
            end
          end
        end

        def toggle_availability?(product_availability, current_availability)
          product_availability != current_availability
        end
      end
    end
  end
end
