module Crawlers
  class ApplicationCrawler
    require 'nokogiri'
    require 'open-uri'

    class << self
      def wrong_encoding_chars
        ["\u0081", "\u0083O", "\u0089", "\u0094", "\u0093"]
      end

      def include_wrong_encoding_chars?(product)
        wrong_encoding_chars.any? { |word| product.include?(word) }
      end

      def sick_encoding_chars
        ['Ã¡', 'Ã¢', 'Ã£', 'Ã©', 'Ãª', 'Ã­', 'Ã³', 'Ã´', 'Ãµ', 'Ãº', 'Ã§', 'Âº',
         "Ã\u0082"]
      end

      def is_sick?(product_name)
        sick_encoding_chars.any? { |word| product_name.include?(word) }
      end
    end
  end
end
