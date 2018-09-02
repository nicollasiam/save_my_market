module Crawlers
  module HomeRefill
    class RegistrationCrawler < ApplicationCrawler
      HOME_REFILL_BASE_URL = 'https://www.homerefill.com.br/'.freeze
      HOME_REFILL_MODEL = Market.find_by(name: 'Home Refill')

      class << self
        def execute
          @products = []
          page_number = 2
          home = Nokogiri::HTML(open(HOME_REFILL_BASE_URL))

          # Get all catergories links
          # At Home Refill website, all categories are in 'shopping' main category
          links = home.css('a')
                      .map { |a| a.attr('href').gsub('https://www.homerefill.com.br/', '') rescue nil }
                      .select{ |b| (b.include?('shopping') rescue false) && b.split('/').size == 2 }
                      .uniq

          # Visit all caterories
          links.each do |link|
            begin
              # puts '+++++++++++++++++++++++++++++++++++++++ PROXIMA CATEGORIA +++++++++++++++++++++++++++++++++++++++'
              category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}"))

              # Loop the first products
              loop_through_category(category)
              # Click next button and continue visiting products
              category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}?page=2"))

              # Stop only of next page is nil
              until category.css('section.row .column.small-16.large-12').first.text().strip.blank?
                # puts '---------------------------------------- PROXIMA PÁGINA ----------------------------------------'
                loop_through_category(category)

                category = Nokogiri::HTML(open("#{HOME_REFILL_BASE_URL}#{link}?page=#{page_number + 1}"))
                page_number += 1
              end
            rescue
              puts "Erro! Vida que segue!"
            end
          end
        end

        private

        def loop_through_category(category)
          category.css('.column .molecule-new-product-card .row.uncollapse').each do |product_html|
            product_name = product_html.css('h3').text().strip
            price = product_html.css('.molecule-new-product-card__price').text().gsub('R$', '').gsub(',', '.').strip.to_f
            product_url = product_html.css('.column.small-16.small-order-1 a').attr('href').value.strip

            # If the price is zero, this and next products are not availble anymore
            break if price.zero?
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
                                        image: (product_html.css('.atom-product-image img').attr('src').text().strip rescue ''),
                                        market_name: 'home_refill',
                                        market: HOME_REFILL_MODEL,
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
