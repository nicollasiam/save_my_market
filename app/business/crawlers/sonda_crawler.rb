module Crawlers
  class SondaCrawler < ApplicationCrawler
    SONDA_BASE_URL = 'https://www.sondadelivery.com.br/'.freeze
    SONDA_MODEL = Market.find_by(name: 'Sonda')
    SONDA_PRODUCTS = SONDA_MODEL.products.pluck(:name)

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        home = Nokogiri::HTML(open(SONDA_BASE_URL))

        # Get all catergories links
        links = home.css('ul.nav.navbar-nav li.section-menu .nav-sections ul:not(.nav-shop_sub) li a')
                    .map { |element| element.attr('href') }.uniq

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open("#{SONDA_BASE_URL}#{link}"))

            # Loop the first products
            loop_through_category(category)

            # Click next button and continue visiting products
            next_page = category.css('.input-qtd-inc a').attr('href').value().strip

            # Stop only of next page is nil
            until next_page.nil?
              # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              category = Nokogiri::HTML(open("#{SONDA_BASE_URL}#{next_page}"))

              loop_through_category(category)

              next_page = (category.css('.input-qtd-inc a').attr('href').value().strip rescue nil)
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end
      end

      private

      def loop_through_category(category)
        category.css('.product').each do |product_html|
          product_name = product_html.css('.product--info .tit').text().strip
          price = product_html.css('.product--info .price').text().strip.gsub(',', '.').to_f

          # If the price is zero, this and next products are not availble anymore
          break if price.zero?
          next if include_wrong_encoding_chars?(product_name)

          # Fix product name if it has wrong encoding
          # So it is not added again in the database
          product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

          # Product already exists in database
          if SONDA_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: SONDA_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.order(created_at: :asc).last.current_price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.current_price,
                                              current_price: price,
                                              product: product)

              product.update(price: price,
                             url: "#{SONDA_BASE_URL}#{product_html.css('[itemprop=url]').attr('href').value.strip}")
              puts "PRODUTO ATUALIZADO. #{product.name}: #{product.price_histories.last.old_price} -> #{product.price_histories.last.current_price}"
            else
              product.update(url: "#{SONDA_BASE_URL}#{product_html.css('[itemprop=url]').attr('href').value.strip}")
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: (product_html.css('.lnk img').attr('src').value().strip rescue ''),
                                      market_name: 'sonda',
                                      market: SONDA_MODEL,
                                      url: "#{SONDA_BASE_URL}#{product_html.css('[itemprop=url]').attr('href').value.strip}")

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
