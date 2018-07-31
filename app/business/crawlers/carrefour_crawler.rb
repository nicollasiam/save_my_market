module Crawlers
  class CarrefourCrawler < ApplicationCrawler
    CARREFOUR_BASE_URL = 'https://www.carrefour.com.br'.freeze
    CARREFOUR_HOME_URL = 'https://www.carrefour.com.br/dicas/mercado'.freeze

    CARREFOUR_MODEL = Market.find_by(name: 'Carrefour')
    CARREFOUR_PRODUCTS = CARREFOUR_MODEL.products.pluck(:name)

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        home = Nokogiri::HTML(open(CARREFOUR_HOME_URL))

        # Get all catergories links
        links = home.css('#boxes-menulateral ul li ul li a').map { |category| category.attr('href') }

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open("#{CARREFOUR_BASE_URL}#{link}"))

            # Loop the first products
            loop_through_category(category)

            # Click next button and continue visiting products
            next_page = (category.css('#loadNextPage').attr('href').value rescue nil)

            # Stop only of next page is nil
            until next_page.nil?
              # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              category = Nokogiri::HTML(open(next_page))

              loop_through_category(category)

              next_page = (category.css('#loadNextPage').attr('href').value rescue nil)
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end
      end

      private

      def loop_through_category(category)
        category.css('.prd-info').each do |product|
          product_name = product.css('.prd-name').text().strip
          price = product.css('.prd-price-new').text().gsub('R$', '').gsub(',', '.').strip.to_f

          # If the price is zero, this and next products are not availble anymore
          break if price.zero?
          next if include_wrong_encoding_chars?(product_name)

          # Product already exists in database
          if CARREFOUR_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: CARREFOUR_MODEL)

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
                                      image: '',
                                      market_name: 'carrefour',
                                      market: CARREFOUR_MODEL)

            # create the first price history
            new_price = PriceHistory.create(old_price: 0,
                                            current_price: price,
                                            product: product)

            puts "NOVO PRODUTO: #{product.name} -> #{product.price} "
          end
        end
      end

      def include_wrong_encoding_chars?(product_name)
        wrong_encoding_chars.any? { |word| product_name.include?(word) }
      end
    end
  end
end
