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
        Product.where(name: '').destroy_all
        Product.where(name: nil).destroy_all
      end
    end
  end
end
