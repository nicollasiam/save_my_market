module Crawlers
  module Dia
    class RegistrationCrawler < ApplicationCrawler
      DIA_BASE_URL = 'https://www.dia.com.br/'.freeze
      DIA_MODEL = Market.find_by(name: 'Dia')

      class << self
        def execute
          @products = []
          page_number = 2
          home = Nokogiri::HTML(open(DIA_BASE_URL))

          # Get all catergories links
          links = home.css('.catalogo li.nav-item a').map { |category| category.attr('href') }

          # Visit all caterories
          links.each do |link|
            begin
              # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
              category = Nokogiri::HTML(open(link))
              # Loop the first products
              loop_through_category(category)
              # Click next button and continue visiting products
              category = Nokogiri::HTML(open("#{link}?page=2"))

              # Stop only of next page is nil
              until category.css('a.shelf-url').empty?
                # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
                loop_through_category(category)

                category = Nokogiri::HTML(open("#{link}?page=#{page_number + 1}"))
                page_number += 1
              end
            rescue
              puts "Erro! Vida que segue!"
            end
          end
        end

        private

        def loop_through_category(category)
          category.css('.box-product').each do |product_html|
            product_name = product_html.css('.shelf-item-name').text.strip
            product_url = "#{DIA_BASE_URL}#{product_html.css('.shelf-url').attr('href').value.strip}"
            price = product_html.css('.bestPrice .val').text.gsub('R$', '').gsub(',', '.').strip.to_f

            # If the price is zero, this and next products are not availble anymore
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
                                       image: (product_html.css('figure.image img').attr('src').value.strip rescue ''),
                                       market_name: 'dia',
                                       market: DIA_MODEL,
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
