module Crawlers
  module PaoDeAcucar
    class RegistrationCrawler < Crawlers::ApplicationCrawler
      # Pao de açucar uses Angular apps
      # which means that the calls are made through an api
      # and the responses are a bunch os JSONs
      PAO_DE_ACUCAR_IMG_BASE_URL = 'https://www.paodeacucar.com'.freeze

      PAO_DE_ACUCAR_HOME_URL = 'https://api.gpa.digital/pa/detail/categories?storeId=501&split=&showSub=true'.freeze
      PAO_DE_ACUCAR_BASE_URL = 'https://api.gpa.digital/pa/products/list'.freeze

      # 36 is the maximun page size the api allows
      PAO_DE_ACUCAR_QUERY_STRING = '?storeId=501&qt=36&s=&ftr=&rm=&gt=list&isClienteMais=false'.freeze

      PAO_DE_ACUCAR_MODEL = Market.find_by(name: 'Pão de Açucar')

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
          category['content']['products'].each do |product_html|
            next unless product_html['stock']

            product_name = product_html['name'].strip
            product_url = "#{PAO_DE_ACUCAR_IMG_BASE_URL}#{product_html['urlDetails']}"
            price = product_html['currentPrice']

            next if include_wrong_encoding_chars?(product_name)

            # Fix product name if it has wrong encoding
            # So it is not added again in the database
            product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

            # Look for url
            # because after many tries
            # it seems to be the most uniq, error-free attribute
            # Product is not in database
            if Product.where(url: product_url).empty?
              # This is a new product
              # add it to the database
              product = Product.create(name: product_name,
                                       price: price,
                                       image: ("#{PAO_DE_ACUCAR_IMG_BASE_URL}#{product_html['thumbPath']}" rescue ''),
                                       market_name: 'pao_de_acucar',
                                       market: PAO_DE_ACUCAR_MODEL,
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
