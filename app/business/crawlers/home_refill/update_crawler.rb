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

              # Update title
              update_title(product_model, product_html)

              # Update price
              update_price(product_model, product_html)
            rescue
              # TODO: Implement availability attribute
              # NOTE: THERE IS NOT YET A WAY TO CHECK
              # THE PRODUCT AVAILABILITY AT home_refill
              puts "URL ZUADA: #{product_model.name} (#{product_model.market.name})"
            end
          end
        end

        # check if price changed
        # do nothing if it did not
        def update_price(product_model, product_html)
          price = product_html.css('.molecule-product-featured__price')
                              .text.gsub('R$', '').gsub(',', '.')
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
          product_name = product_html.css('h3.molecule-product-featured__description')
                                     .text.strip
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
