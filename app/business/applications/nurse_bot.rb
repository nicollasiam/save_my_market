module Applications
  class NurseBot
    ENCODING_EQUIVALENTS = { 'Ã¡' => 'á',
                             'Ã¢' => 'â',
                             'Ã£' => 'ã',
                             'Ã©' => 'é',
                             'Ãª' => 'ê',
                             'Ã­'  => 'í', # THERE IS A HIDDEN CHARACTER HERE, AFTER Ã
                             'Ã³' => 'ó',
                             'Ã´' => 'ô',
                             'Ãµ' => 'õ',
                             'Ãº' => 'ú',
                             'Ã§' => 'ç'
                           }

    class << self
      def treat_injuries
        fix_wrong_encoding_characters
      end

      def treat_product_name(product_name)
        ENCODING_EQUIVALENTS.keys.each do |char|
          product_name.gsub!(char, ENCODING_EQUIVALENTS[char])
        end

        product_name
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
