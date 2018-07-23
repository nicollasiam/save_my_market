module Crawlers
  class PaoDeAcucarCrawler
    # Pao de açucar uses Angular apps
    # which means that the calls are made through an api
    # and the responses are a bunch os JSONs
    PAO_DE_ACUCAR_IMG_BASE_URL = 'https://www.paodeacucar.com'.freeze

    PAO_DE_ACUCAR_HOME_URL = 'https://api.gpa.digital/pa/detail/categories?storeId=501&split=&showSub=true'.freeze
    PAO_DE_ACUCAR_BASE_URL = 'https://api.gpa.digital/pa/products/list'.freeze

    # 36 is the maximun page size the api allows
    PAO_DE_ACUCAR_QUERY_STRING = '?storeId=501&qt=36&s=&ftr=&rm=&gt=list&isClienteMais=false'.freeze

    PAO_DE_ACUCAR_MODEL = Market.find_by(name: 'Pão de Açucar')

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        last_page = false
        page = 0

        home = JSON.parse(Nokogiri::HTML(open(PAO_DE_ACUCAR_HOME_URL)))
        # Get all catergories links
        links = home['content'].map { |category| category['link'] }

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'

            until last_page
              category = JSON.parse(Nokogiri::HTML(open("#{PAO_DE_ACUCAR_BASE_URL}#{link}#{PAO_DE_ACUCAR_QUERY_STRING}&p=#{page}")))
              # Loop the first products
              loop_through_category(category)

              page += 1
              last_page = category['content']['last']
            end
          rescue
            puts "Erro! Vida que segue!"
          end

          page = 0
        end

        @products.uniq.each do |product_hash|
          product = Product.new(product_hash)
          product.market = PAO_DE_ACUCAR_MODEL
          product.save
        end
      end

      private

      def loop_through_category(category)
        category['content']['products'].each do |product|
          next unless product['stock']

          # puts "#{product['name'].strip}: #{product['currentPrice']}"
          @products << { name: product['name'].strip,
                         price: product['currentPrice'],
                         image: ("#{PAO_DE_ACUCAR_IMG_BASE_URL}#{product['thumbPath']}" rescue ''),
                         market_name: 'pao_de_acucar'
                       }
        end
      end
    end
  end
end
