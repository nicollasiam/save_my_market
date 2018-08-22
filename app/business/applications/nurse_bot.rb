module Applications
  class NurseBot
    ENCODING_EQUIVALENTS = { 'Ã¡' => 'á',
                             'Ã¢' => 'â',
                             'Ã£' => 'ã',
                             'Ã©' => 'é',
                             'Ãª' => 'ê',
                             'Ã³' => 'ó',
                             'Ã´' => 'ô',
                             'Ãº' => 'ú',
                             'Ã§' => 'ç'
                           }

    class << self
      def treat_injuries
        fix_wrong_encoding_characters
      end

      private

      def fix_wrong_encoding_characters
        ENCODING_EQUIVALENTS.keys.each do |char|
          products = Product.where('name LIKE ?', "%#{char}%")

          products.each do |product|
            product.update(name: product.name.gsub(char, ENCODING_EQUIVALENTS[char]))
          end
        end
      end
    end
  end
end
