module Crawlers
  module Carrefour
    class UpdateCrawler < Crawlers::ApplicationCrawler
      CARREFOUR_PRODUCTS = Product.where(market_name: 'carrefour')

      class << self
        def execute
          update_carrefour_products
        end

        private

        def update_carrefour_products
          CARREFOUR_PRODUCTS.each do |product_model|
            begin
              product_html = Nokogiri::HTML(open(product_model.url))

              price = product_html.css('.priceBig').text.split("\n").last
                                  .strip.gsub('R$', '').gsub(',', '.')
                                  .strip.to_f

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
              # TODO: Implement availability attribute
              # check if product is available
              begin
                if product_html.css('.text-not-product-avisme').text.present?
                  # product_model.update(available: false)
                  puts "PRODUTO INDISPONÍVEL: #{product_model.name} (#{product_model.market.name})"
                else
                  puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
                end
              rescue
                puts "ERRO INESPERADO"
              end
            end
          end
        end
      end
    end
  end
end
