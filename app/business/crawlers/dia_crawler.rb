module Crawlers
  class DiaCrawler
    DIA_BASE_URL = 'https://www.dia.com.br/'.freeze

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
        links.each_with_index do |link, index|
          begin
            puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open(link))

            # Loop the first products
            loop_through_category(category)
            # Click next button and continue visiting products
            category = Nokogiri::HTML(open("#{link}?page=2"))

            # Stop only of next page is nil
            until category.css('a.shelf-url').empty?
              puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              loop_through_category(category)

              category = Nokogiri::HTML(open("#{link}?page=#{page_number + 1}"))
              page_number += 1
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end

        Product.create!(@products)
      end

      private

      def loop_through_category(category)
        category.css('a.shelf-url').each do |element|
          product_url = element.attr('href')
          product = Nokogiri::HTML(open("#{DIA_BASE_URL}#{product_url}"))

          puts "#{product.css('h1.nameProduct').text().strip}: #{product.css('.line.price-line p.bestPrice span.val').text().gsub('R$', '').gsub(',', '.').strip.to_f}"
          @products << { name: product.css('h1.nameProduct').text().strip,
                         price: product.css('.line.price-line p.bestPrice span.val').text().gsub('R$', '').gsub(',', '.').strip.to_f,
                         image: (product.css('#list-thumbs').first.css('a').attr('href').value rescue ''),
                         market: 'dia'
                       }
        end
      end
    end
  end
end
