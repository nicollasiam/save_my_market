module Crawlers
  class HomeRefillCrawler < ApplicationCrawler
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
        category.css('.column .molecule-new-product-card .row.uncollapse').each do |product_html|
          product_name = product_html.css('h3').text().strip
          price = product_html.css('.molecule-new-product-card__price').text().gsub('R$', '').gsub(',', '.').strip.to_f
          product_url = product_html.css('.column.small-16.small-order-1 a').attr('href').value.strip

          # If the price is zero, this and next products are not availble anymore
          break if price.zero?
          next if include_wrong_encoding_chars?(product_name)

          # Fix product name if it has wrong encoding
          # So it is not added again in the database
          product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

          # Product already exists in database
          if HOME_REFILL_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: HOME_REFILL_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.order(created_at: :asc).last.current_price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.current_price,
                                              current_price: price,
                                              product: product)

              product.update(price: price,
                             url: product_url)
              puts "PRODUTO ATUALIZADO. #{product.name}: #{product.price_histories.last.old_price} -> #{product.price_histories.last.current_price}"
            else
              product.update(url: product_url)
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: (product_html.css('.atom-product-image img').attr('src').text().strip rescue ''),
                                      market_name: 'home_refill',
                                      market: HOME_REFILL_MODEL,
                                      url: product_url)

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
