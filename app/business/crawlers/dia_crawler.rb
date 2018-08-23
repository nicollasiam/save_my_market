module Crawlers
  class DiaCrawler < ApplicationCrawler
    DIA_BASE_URL = 'https://www.dia.com.br/'.freeze
    DIA_MODEL = Market.find_by(name: 'Dia')
    DIA_PRODUCTS = DIA_MODEL.products.pluck(:name)

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        page_number = 2
        home = Nokogiri::HTML(open(DIA_BASE_URL))

        # Get all catergories links
        links = home.css('.catalogo li.nav-item a').map { |category| category.attr('href') }

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open(link))

            # Loop the first products
            loop_through_category(category)
            # Click next button and continue visiting products
            category = Nokogiri::HTML(open("#{link}?page=2"))

            # Stop only of next page is nil
            until category.css('a.shelf-url').empty?
              # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              loop_through_category(category)

              category = Nokogiri::HTML(open("#{link}?page=#{page_number + 1}"))
              page_number += 1
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end
      end

      private

      def loop_through_category(category)
        category.css('a.shelf-url').each do |element|
          product_url = element.attr('href')
          product = Nokogiri::HTML(open("#{DIA_BASE_URL}#{product_url}"))

          product_name = product.css('h1.nameProduct').text().strip
          price = product.css('.line.price-line p.bestPrice span.val').text().gsub('R$', '').gsub(',', '.').strip.to_f

          # If the price is zero, this and next products are not availble anymore
          break if price.zero?
          next if include_wrong_encoding_chars?(product_name)

          # Fix product name if it has wrong encoding
          # So it is not added again in the database
          product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

          # Product already exists in database
          if DIA_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: DIA_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.last.current_price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.current_price,
                                              current_price: price,
                                              product: product)

              product.update(price: price,
                             url: "#{DIA_BASE_URL}#{product_url}")
              puts "PRODUTO ATUALIZADO. #{product.name}: #{product.price_histories.last.old_price} -> #{product.price_histories.last.current_price}"
            else
              product.update(url: "#{DIA_BASE_URL}#{product_url}")
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: (product.css('#list-thumbs').first.css('a').attr('href').value rescue ''),
                                      market_name: 'dia',
                                      market: DIA_MODEL,
                                      url: "#{DIA_BASE_URL}#{product_url}")

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
