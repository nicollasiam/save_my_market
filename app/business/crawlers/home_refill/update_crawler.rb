module Crawlers
  module HomeRefill
    class UpdateCrawler < Crawlers::ApplicationCrawler
      HOME_REFILL_PRODUCTS = Product.where(market_name: 'home_refill')

      class << self
        def execute
          update_home_refill_products
        end

        private

        def update_home_refill_products
          HOME_REFILL_PRODUCTS.each do |product_model|
            begin
              product_html = Nokogiri::HTML(open(product_model.url))

              price = product_html.css('.molecule-product-featured__price')
                                  .text.gsub('R$', '').gsub(',', '.')
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
              # NOTE: THERE IS NOT YET A WAY TO CHECK
              # THE PRODUCT AVAILABILITY AT home_refill
              puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
            end
          end
        end
      end
    end
  end
end
