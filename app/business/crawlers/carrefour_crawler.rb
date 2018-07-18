module Crawlers
  class CarrefourCrawler
    CARREFOUR_BASE_URL = 'https://www.carrefour.com.br'.freeze
    CARREFOUR_HOME_URL = 'https://www.carrefour.com.br/dicas/mercado'.freeze

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        products = []
        home = Nokogiri::HTML(open(CARREFOUR_HOME_URL))

        # Get all catergories links
        links = home.css('#boxes-menulateral ul li ul li a').map { |category| category.attr('href') }

        # Visit all caterories
        links.each_with_index do |link, index|
          begin
            category = Nokogiri::HTML(open("#{CARREFOUR_BASE_URL}#{link}"))

            category.css('.prd-info').each do |product|
              products << [product.css('.prd-name').text().strip,
                            product.css('.prd-price-new').text().gsub('R$', '').gsub(',', '.').strip.to_f]
            end
          rescue
            puts "Erro! Vida que segue!"
          end
        end

        products
      end
    end
  end
end
