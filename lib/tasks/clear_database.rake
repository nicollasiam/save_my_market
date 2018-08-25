namespace :clear_database do
  desc "Clear carrefour price histories"
  task clear_carrefour_prices: :environment do
    Product.where(market_name: 'carrefour').each do |product|
      if product.price_histories.count > 1
        puts "Clearing prices: #{product.name}"
        product.price_histories.each do |price_history|
          price_history.destroy unless price_history.old_price.zero?
        end
      end
    end
  end
end
