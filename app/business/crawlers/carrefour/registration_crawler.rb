module Crawlers
  module Carrefour
    class RegistrationCrawler < Crawlers::ApplicationCrawler
      CARREFOUR_BASE_URL = 'https://www.carrefour.com.br'.freeze
      CARREFOUR_HOME_URL = 'https://www.carrefour.com.br/dicas/mercado'.freeze

      CARREFOUR_MODEL = Market.find_by(name: 'Carrefour')

      class << self
        def execute
          @products = []
          home = Nokogiri::HTML(open(CARREFOUR_HOME_URL))

          # Get all catergories links
          links = home.css('#boxes-menulateral ul li ul li a').map { |category| category.attr('href') }

          # Visit all caterories
          links.each do |link|
            begin
              # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
              category = Nokogiri::HTML(open("#{CARREFOUR_BASE_URL}#{link}"))
              # Loop the first products
              loop_through_category(category)

              # Click next button and continue visiting products
              next_page = (category.css('#loadNextPage').attr('href').value rescue nil)

              # Stop only of next page is nil
              until next_page.nil?
                # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
                category = Nokogiri::HTML(open(next_page))

                loop_through_category(category)

                next_page = (category.css('#loadNextPage').attr('href').value rescue nil)
              end
            rescue
              puts "Erro! Vida que segue!"
            end
          end
        end

        private

        def loop_through_category(category)
          category.css('[itemprop=itemListElement]').each_with_index do |product_html, index|
            product_name = product_html.css('[itemprop=name]')[index].attr('content').strip
            price = product_html.css('[name=productPostPrice]')[index].attr('value').strip.to_f
            product_url = product_html.css('[itemprop=url]')[index].attr('content').strip

            next if include_wrong_encoding_chars?(product_name)

            # Fix product name if it has wrong encoding
            # So it is not added again in the database
            product_name = Applications::NurseBot.treat_product_name(product_name) if is_sick?(product_name)

            # Look for url
            # because after many tries
            # it seems to be the most uniq, error-free attribute
            # Product is not in database
            if Product.where(url: product_url).empty?
              # Add it to the database
              product = Product.create(name: product_name,
                                        price: price,
                                        image: (product_html.css('[itemprop=image]')[index].attr('data-src').strip rescue ''),
                                        market_name: 'carrefour',
                                        market: CARREFOUR_MODEL,
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
