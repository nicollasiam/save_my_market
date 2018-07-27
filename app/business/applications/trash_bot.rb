module Applications
  class TrashBot
    class << self
      def trashify
        destroy_zero_price_products
        destroy_invalid_name_products
      end

      private

      def destroy_zero_price_products
        Product.where(price: 0).destroy_all
      end

      def destroy_invalid_name_products
        wrong_encoding_chars = ["\u0081", 'Ã³', 'Ã§', 'Ã¢', "\u0083O", 'Ãª', 'Ã¡', 'Ã£', "\u0089", "\u0094"]

        Product.where(name: '').destroy_all
        Product.where(name: nil).destroy_all

        wrong_encoding_chars.each do |char|
          Product.where('name LIKE ?', "%#{char}%").destroy_all
        end
      end
    end
  end
end
