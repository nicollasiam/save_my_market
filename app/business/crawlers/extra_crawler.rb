module Crawlers
  class ExtraCrawler
    # Extra uses Angular apps
    # which means that the calls are made through an api
    # and the responses are a bunch os JSONs
    EXTRA_IMG_BASE_URL = 'https://www.deliveryextra.com.br/'.freeze

    EXTRA_HOME_URL = 'https://api.gpa.digital/ex/detail/categories?storeId=241&split=&showSub=true'.freeze
    EXTRA_BASE_URL = 'https://api.gpa.digital/ex/products/list'.freeze

    # 36 is the maximun page size the api allows
    EXTRA_QUERY_STRING = '?storeId=241&qt=36&s=&ftr=&rm=&gt=list&isClienteMais=false'.freeze

    EXTRA_MODEL = Market.find_by(name: 'Extra')

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        last_page = false
        page = 0

        home = JSON.parse(Nokogiri::HTML(open(EXTRA_HOME_URL)))
        # Get all catergories links
        links = home['content'].map { |category| category['link'] }

        # Visit all caterories
        links.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'

            until last_page
              category = JSON.parse(Nokogiri::HTML(open("#{EXTRA_BASE_URL}#{link}#{EXTRA_QUERY_STRING}&p=#{page}")))
              # Loop the first products
              loop_through_category(category)

              page += 1
              last_page = category['content']['last']
            end
          rescue
            puts "Erro! Vida que segue!"
          end

          page = 0
          last_page = false
        end

        @products.uniq.each do |product_hash|
          product = Product.new(product_hash)
          product.market = EXTRA_MODEL
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
                         image: ("#{EXTRA_IMG_BASE_URL}#{product['thumbPath']}" rescue ''),
                         market_name: 'extra'
                       }
        end
      end
    end
  end
end
