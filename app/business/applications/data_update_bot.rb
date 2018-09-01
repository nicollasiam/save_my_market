module Applications
  class DataUpdateBot
    class << self
      def execute
        update_variations
      end

      def week_variation(product)
        week_price = (product.price_histories
                             .order(created_at: :asc)
                             .where('created_at >= ?', Time.zone.now - 1.week)
                             .first.current_price rescue nil)

        week_price.nil? ? 0.0 : (((product.price - week_price) * 100) / week_price).round(2)
      end

      private

      def update_variations
        update = false

        Product.all.each do |product|
          week = week_variation(product)
          month = month_variation(product)

          update = true if !product.week_variation.eql?(week) ||
                           !product.month_variation.eql?(month)

          product.update(week_variation: week, month_variation: month) if update

          update = false
        end
      end

      def month_variation(product)
        month_price =(product.price_histories
                             .order(created_at: :asc)
                             .where('created_at >= ?', Time.zone.now - 1.month)
                             .first.current_price rescue nil)

        month_price.nil? ? 0.0 : (((product.price - month_price) * 100) / month_price).round(2)
      end
    end
  end
end
