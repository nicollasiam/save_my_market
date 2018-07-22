module Crawlers
  class HomeRefillCrawler
    HOME_REFILL_BASE_URL = 'https://www.homerefill.com.br/'.freeze
    HOME_REFILL_MODEL = Market.find_by(name: 'Home Refill')

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

        @products.uniq.each do |product_hash|
          product = Product.new(product_hash)
          product.market = HOME_REFILL_MODEL
          product.save
        end
      end

      private

      def loop_through_category(category)
        category.css('.column .molecule-new-product-card .row.uncollapse').each do |product|
          price = product.css('.molecule-new-product-card__price').text().gsub('R$', '').gsub(',', '.').strip.to_f
          # If the price is zero, this and next products are not availble anymore
          break if price.zero?

          # puts "#{product.css('h3').text().strip}: #{price}"
          @products << { name: product.css('h3').text().strip,
                         price: price,
                         image: (product.css('.atom-product-image img').attr('src').text().strip rescue ''),
                         market: 'home_refill'
                       }
        end
      end
    end
  end
end
