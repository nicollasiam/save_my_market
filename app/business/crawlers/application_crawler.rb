module Crawlers
  class ApplicationCrawler
    class << self
      def wrong_encoding_chars
        ["\u0081", 'Ã³', 'Ã§', 'Ã¢', "\u0083O", 'Ãª', 'Ã¡', 'Ã£', "\u0089", "\u0094", "\u0093", 'Ã©']
      end
    end
  end
end
