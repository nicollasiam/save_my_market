module Crawlers
  class HomeRefillCrawler
    HOME_REFILL_BASE_URL = 'https://www.homerefill.com.br/'.freeze
    HOME_REFILL_MODEL = Market.find_by(name: 'Home Refill')
    HOME_REFILL_PRODUCTS = HOME_REFILL_MODEL.products.pluck(:name)

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        page_number = 2
        home = Nokogiri::HTML(open(HOME_REFILL_BASE_URL))

        # Get all catergories links
        # At Home Refill website, all categories are in 'shopping' main category
        links = home.css('a')
                    .map { |a| a.attr('href').gsub('https://www.homerefill.com.br/', '') rescue nil }
                    .select{ |b| (b.include?('shopping') rescue false) && b.split('/').size == 2 }
                    .uniq

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}"))

            # Loop the first products
            loop_through_category(category)
            # Click next button and continue visiting products
            category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}?page=2"))

            # Stop only of next page is nil
            until category.css('section.row .column.small-16.large-12').first.text().strip.blank?
              # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              loop_through_category(category)

              category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}?page=#{page_number + 1}"))
              page_number += 1
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end
      end

      private

      def loop_through_category(category)
        category.css('.column .molecule-new-product-card .row.uncollapse').each do |product|
          product_name = product.css('h3').text().strip
          price = product.css('.molecule-new-product-card__price').text().gsub('R$', '').gsub(',', '.').strip.to_f

          # If the price is zero, this and next products are not availble anymore
          break if price.zero?

          # Product already exists in database
          if HOME_REFILL_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: HOME_REFILL_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.last.current_price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.current_price,
                                              current_price: price,
                                              product: product)

              product.update(price: price)
              puts "PRODUTO ATUALIZADO. #{product.name}: #{product.price_histories.last.old_price} -> #{product.price_histories.last.current_price}"
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: (product.css('.atom-product-image img').attr('src').text().strip rescue ''),
                                      market_name: 'home_refill',
                                      market: HOME_REFILL_MODEL)

            # create the first price history
            new_price = PriceHistory.create(old_price: 0,
                                            current_price: price,
                                            product: product)

            puts "NOVO PRODUTO: #{product.name} -> #{product.price} "
          end
        end
      end
    end
  end
end
