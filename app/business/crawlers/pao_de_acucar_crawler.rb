module Crawlers
  class PaoDeAcucarCrawler
    # Pao de açucar uses Angular apps
    # which means that the calls are made through an api
    # and the responses are a bunch os JSONs
    PAO_DE_ACUCAR_IMG_BASE_URL = 'https://www.paodeacucar.com'.freeze

    PAO_DE_ACUCAR_HOME_URL = 'https://api.gpa.digital/pa/detail/categories?storeId=501&split=&showSub=true'.freeze
    PAO_DE_ACUCAR_BASE_URL = 'https://api.gpa.digital/pa/products/list'.freeze

    # Pass 10k to the qty, I dont belive a category has more than 10k items
    PAO_DE_ACUCAR_QUERY_STRING = '?storeId=501&qt=10000&s=&ftr=&p=1&rm=&gt=list&isClienteMais=false'.freeze

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        home = JSON.parse(Nokogiri::HTML(open(PAO_DE_ACUCAR_HOME_URL)))
        # Get all catergories links
        links = home['content'].map { |category| category['link'] }

        # Visit all caterories
        links.each do |link|
          begin
            debugger
            puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = JSON.parse(Nokogiri::HTML(open("#{PAO_DE_ACUCAR_BASE_URL}#{link}#{PAO_DE_ACUCAR_QUERY_STRING}")))

            # Loop the first products
            loop_through_category(category)
          rescue
            puts "Erro! Vida que segue!"
          end
        end

        Product.create!(@products)
      end

      private

      def loop_through_category(category)
        category['content']['products'].each do |product|
          next unless product['stock']
          puts "#{product['name'].strip}: #{product['currentPrice'].strip.to_f}"
          @products << { name: product['name'].strip,
                         price: product['currentPrice'].strip.to_f,
                         image: ("#{PAO_DE_ACUCAR_IMG_BASE_URL}#{product['thumbPath']}" rescue ''),
                         market: 'pao_de_acucar'
                       }
        end
      end
    end
  end
end
