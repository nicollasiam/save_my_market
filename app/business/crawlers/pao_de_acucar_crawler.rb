module Crawlers
  class PaoDeAcucarCrawler < ApplicationCrawler
    # Pao de açucar uses Angular apps
    # which means that the calls are made through an api
    # and the responses are a bunch os JSONs
    PAO_DE_ACUCAR_IMG_BASE_URL = 'https://www.paodeacucar.com'.freeze

    PAO_DE_ACUCAR_HOME_URL = 'https://api.gpa.digital/pa/detail/categories?storeId=501&split=&showSub=true'.freeze
    PAO_DE_ACUCAR_BASE_URL = 'https://api.gpa.digital/pa/products/list'.freeze

    # 36 is the maximun page size the api allows
    PAO_DE_ACUCAR_QUERY_STRING = '?storeId=501&qt=36&s=&ftr=&rm=&gt=list&isClienteMais=false'.freeze

    PAO_DE_ACUCAR_MODEL = Market.find_by(name: 'Pão de Açucar')
    PAO_DE_ACUCAR_PRODUCTS = PAO_DE_ACUCAR_MODEL.products.pluck(:name)

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

          last_page = false
          page = 0
        end
      end

      private

      def loop_through_category(category)
        category['content']['products'].each do |product|
          next unless product['stock']

          product_name = product['name'].strip
          price = product['currentPrice']

          next if include_wrong_encoding_chars?(product_name)

          # Product already exists in database
          if PAO_DE_ACUCAR_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: PAO_DE_ACUCAR_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.last.current_price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.current_price,
                                              current_price: price,
                                              product: product)

              product.update(price: price)
              puts "PRODUTO ATUALIZADO. #{product.name}: #{product.price_histories.last.old_price} -> #{product.price_histories.last.current_price}"
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: ("#{PAO_DE_ACUCAR_IMG_BASE_URL}#{product['thumbPath']}" rescue ''),
                                      market_name: 'pao_de_acucar',
                                      market: PAO_DE_ACUCAR_MODEL)

            # create the first price history
            new_price = PriceHistory.create(old_price: 0,
                                            current_price: price,
                                            product: product)

            puts "NOVO PRODUTO: #{product.name} -> #{product.price} "
          end
        end
      end

      def include_wrong_encoding_chars?(product_name)
        wrong_encoding_chars.any? { |word| product_name.include?(word) }
      end
    end
  end
end
