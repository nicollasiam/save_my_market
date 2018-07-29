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
    EXTRA_PRODUCTS = EXTRA_MODEL.products.pluck(:name)

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

          last_page = false
          page = 0
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

          product_name = product['name'].strip
          price = product['currentPrice']

          # Product already exists in database
          if EXTRA_PRODUCTS.include?(product_name)
            product = Product.where(name: product_name, market: EXTRA_MODEL)

            # check if price changed
            # do nothing if it did not
            if product.price_histories.last.price != price
              # if it changed, create a new price history and add it to the product
              new_price = PriceHistory.create(old_price: product.price_histories.last.price,
                                              current_price: price,
                                              product: product)

              product.update(price: price)
            end
          else
            # This is a new product
            # add it to the database
            product = Product.create(name: product_name,
                                      price: price,
                                      image: ("#{EXTRA_IMG_BASE_URL}#{product['thumbPath']}" rescue ''),
                                      market_name: 'extra',
                                      market: EXTRA_MODEL)

            # create the first price history
            new_price = PriceHistory.create(old_price: 0,
                                            current_price: price,
                                            product: product)
          end
        end
      end
    end
  end
end
