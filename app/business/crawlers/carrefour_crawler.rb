module Crawlers
  class CarrefourCrawler
    CARREFOUR_BASE_URL = 'https://www.carrefour.com.br'.freeze
    CARREFOUR_HOME_URL = 'https://www.carrefour.com.br/dicas/mercado'.freeze

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
            puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open("#{CARREFOUR_BASE_URL}#{link}"))

            # Loop the first products
            loop_through_category(category)

            # Click next button and continue visiting products
            next_page = (category.css('#loadNextPage').attr('href').value rescue nil)

            # Stop only of next page is nil
            until next_page.nil?
              puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              category = Nokogiri::HTML(open(next_page))

              loop_through_category(category)

              next_page = (category.css('#loadNextPage').attr('href').value rescue nil)
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end

        all_products = @products.uniq
        Product.create!(all_products)
      end

      private

      def loop_through_category(category)
        category.css('.prd-info').each do |product|
          price = product.css('.prd-price-new').text().gsub('R$', '').gsub(',', '.').strip.to_f
          # If the price is zero, this and next products are not availble anymore
          break if price.zero?

          puts "#{product.css('.prd-name').text().strip}: #{price}"
          @products << { name: product.css('.prd-name').text().strip,
                         price: price,
                         image: '',
                         market: 'carrefour'
                       }
        end
      end
    end
  end
end
