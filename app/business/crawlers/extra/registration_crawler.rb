module Crawlers
  module Extra
    class RegistrationCrawler < Crawlers::ApplicationCrawler
      # Extra uses Angular apps
      # which means that the calls are made through an api
      # and the responses are a bunch os JSONs
      EXTRA_IMG_BASE_URL = 'https://www.deliveryextra.com.br/'.freeze

      EXTRA_HOME_URL = 'https://api.gpa.digital/ex/detail/categories?storeId=241&split=&showSub=true'.freeze
      EXTRA_BASE_URL = 'https://api.gpa.digital/ex/products/list'.freeze

      # 36 is the maximun page size the api allows
      EXTRA_QUERY_STRING = '?storeId=241&qt=36&s=&ftr=&rm=&gt=list&isClienteMais=false'.freeze

      EXTRA_MODEL = Market.find_by(name: 'Extra')

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
        end

        private

        def loop_through_category(category)
          category['content']['products'].each do |product_html|
            next unless product_html['stock']

            product_name = product_html['name'].strip
            product_url = "#{EXTRA_IMG_BASE_URL}#{product_html['urlDetails']}"
            price = product_html['currentPrice']

            next if include_wrong_encoding_chars?(product_name)

            # Fix product name if it has wrong encoding
            # So it is not added again in the database
            product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

            # Look for url
            # because after many tries
            # it seems to be the most uniq, error-free attribute
            # Product does not exist in database
            if Product.where(url: product_url).empty?
              # This is a new product
              # add it to the database
              product = Product.create(name: product_name,
                                        price: price,
                                        image: ("#{EXTRA_IMG_BASE_URL}#{product_html['thumbPath']}" rescue ''),
                                        market_name: 'extra',
                                        market: EXTRA_MODEL,
                                        url: product_url)

              # create the first price history
              new_price = PriceHistory.create(old_price: 0,
                                              current_price: price,
                                              product: product)

              puts "NOVO PRODUTO: #{product.name} -> #{product.price} "
            end
          end
        end
      end
    end
  end
end
