module Crawlers
  class SondaCrawler
    SONDA_BASE_URL = 'https://www.sondadelivery.com.br/'.freeze
    SONDA_MODEL = Market.find_by(name: 'Sonda')

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

        @products.uniq.each do |product_hash|
          product = Product.new(product_hash)
          product.market = SONDA_MODEL
          product.save
        end
      end

      private

      def loop_through_category(category)
        category.css('.product').each do |product|
          price = product.css('.product--info .price').text().strip.gsub(',', '.').to_f

          # puts "#{product.css('.product--info .tit').text().strip}: #{price}"
          @products << { name: product.css('.product--info .tit').text().strip,
                         price: price,
                         image: (product.css('.lnk img').attr('src').value().strip rescue ''),
                         market: 'sonda'
                       }
        end
      end
    end
  end
end
