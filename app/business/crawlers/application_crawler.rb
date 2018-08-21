module Crawlers
  class ApplicationCrawler
    class << self
      def wrong_encoding_chars
        ["\u0081", "\u0083O", "\u0089", "\u0094", "\u0093"]
      end
    end
  end
end
