module Crawlers
  class MamboCrawler
    # Mambo uses vtex, which makes everything weird
    # Its harder to access html AND api calls
    # This is because I derectly got the weird categories urls
    # so I could access directily
    MAMBO_MODEL = Market.find_by(name: 'Mambo')

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

        @products.uniq.each do |product_hash|
          product = Product.new(product_hash)
          product.market = MAMBO_MODEL
          product.save
        end
      end

      private

      def loop_through_category(category)
        category.each do |product_url|
          product = Nokogiri::HTML(open(product_url.attr('data-url')))

          price = product.css('[itemscope]').css('[itemprop=offers]').css('[itemprop=price]').attr('content').value().strip.to_f

          # puts "#{product.css('[itemscope]').css('[itemprop=name]').attr('content').value().strip}: #{price}"
          @products << { name: product.css('[itemscope]').css('[itemprop=name]').attr('content').value().strip,
                         price: price,
                         image: (product.css('[itemscope]').css('[itemprop=image]').attr('content').value().strip rescue ''),
                         market: 'mambo'
                       }
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
    end
  end
end
