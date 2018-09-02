namespace :clear_database do
  desc "Clear carrefour price histories"
  task clear_carrefour_prices: :environment do
    Product.where(market_name: 'carrefour').each do |product|
      next if product.price_histories.count <= 2

      product.price_histories.destroy_all

      PriceHistory.create(old_price: 0,
                          current_price: product.price,
                          product: product)
    end
  end

  desc "Clear mambo price histories"
  task clear_mambo_prices: :environment do
    Product.where(market_name: 'mambo').each do |product|
      next if product.price_histories.count <= 2

      product.price_histories.destroy_all

      PriceHistory.create(old_price: 0,
                          current_price: product.price,
                          product: product)
    end
  end

  desc "Clear sonda price histories"
  task clear_sonda_prices: :environment do
    Product.where(market_name: 'sonda').each do |product|
      next if product.price_histories.count <= 4

      product.price_histories.destroy_all

      PriceHistory.create(old_price: 0,
                          current_price: product.price,
                          product: product)
    end
  end

  desc 'Clear repeated products'
  task clear_repeated_products: :environment do
    Product.group(:url, :market_name).count.each do |key, value|
      # Get all but first products
      prods = Product.where(url: key.first, market_name: key.last).order(:created_at)[1..-1]

      puts "PRODUTO DELETADO: #{key.first} (#{key.last})" if prods.any?
      prods.each { |prod| prod.destroy }
    end
  end

  desc 'Clear Sonda repeated products'
  task clear_sonda_repeated_products: :environment do
    Product.where(market_name: 'sonda').pluck(:name).each do |product_name|
      products = Product.where(market_name: 'sonda', name: product_name)

      if products.count == 2
        puts "PRODUTO REPETIDO: #{products.first.name}"
        products.last.destroy
      end
    end
  end
end
