module Crawlers
  class MamboCrawler < ApplicationCrawler
    # Mambo uses vtex, which makes everything weird
    # Its harder to access html AND api calls
    # This is because I derectly got the weird categories urls
    # so I could access directily
    MAMBO_MODEL = Market.find_by(name: 'Mambo')
    MAMBO_PRODUCTS = MAMBO_MODEL.products.pluck(:name)

    MAMBO_API = 'https://www.mambo.com.br/api/catalog_system/pub/products/search/?fq=productId:'.freeze

    require 'nokogiri'
    require 'open-uri'

    class << self
      def execute
        @products = []
        page_number = 1

        # Visit all caterories
        mambo_categories_urls.each do |link|
          begin
            # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
            category = Nokogiri::HTML(open("#{link}#{page_number}")).css('.widget')

            # Stop only of next page is nil
            until category.empty?
              # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
              loop_through_category(category)

              category = (Nokogiri::HTML(open("#{link}#{page_number + 1}")).css('.widget') rescue [])
              page_number += 1
            end
          rescue
            puts "Erro! Vida que segue!"
          end

          page_number = 1
        end
      end

      private

      def loop_through_category(category)
        category.each do |product_url|
          product = Nokogiri::HTML(open(product_url.attr('data-url')))
          item_id = product.css('[itemscope]').css('[itemprop=productID]').attr('content').value().strip

          product_hash = JSON.parse(Nokogiri::HTML(open("#{MAMBO_API}#{item_id}")))

          product_name = product_hash.first['productName']
          price = (product_hash.first['items'].first['unitMultiplier'].to_f *
                            product_hash.first['items'].first['sellers'].first['commertialOffer']['Installments'].first['Value'].to_f)
                            .round(2)

          next if include_wrong_encoding_chars?(product_name)

          # Product already exists in database
          if MAMBO_PRODUCTS.include?(product_name)
            product = Product.find_by(name: product_name, market: MAMBO_MODEL)

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
                                      image: (product.css('[itemscope]').css('[itemprop=image]').attr('content').value().strip rescue ''),
                                      market_name: 'mambo',
                                      market: MAMBO_MODEL)

            # create the first price history
            new_price = PriceHistory.create(old_price: 0,
                                            current_price: price,
                                            product: product)

            puts "NOVO PRODUTO: #{product.name} -> #{product.price} "
          end
        end
      end

      def mambo_categories_urls
        [ # mercearia
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f4%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # hortifruti
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f6%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # carnes-aves-e-peixes
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f8%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # frios---laticinios
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f2%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # carnes-aves-e-peixes/pescados
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f8%2f458%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # padaria
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f19%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # congelados
          'ttps://www.mambo.com.br/buscapagina?fq=C%3a%2f248%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # bebidas
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f3%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # utensilios-domesticos
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f192%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # limpeza
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f11%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # higiene-e-beleza
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f154%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=',
          # petshop
          'https://www.mambo.com.br/buscapagina?fq=C%3a%2f134%2f&PS=20&sl=ac97b6b4-d928-4c37-a6bb-794c42ce6ba6&cc=20&sm=0&PageNumber=']
      end

      def include_wrong_encoding_chars?(product_name)
        wrong_encoding_chars.any? { |word| product_name.include?(word) }
      end
    end
  end
end
