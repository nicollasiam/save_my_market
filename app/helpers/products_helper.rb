module ProductsHelper
  def registration_price(product)
    product.price_histories.order(created_at: :asc).first.current_price
  end

  def registration_date(product)
    product.price_histories.order(created_at: :asc).first.created_at.strftime('%d/%m/%Y')
  end

  def minimum_price(product)
    product.price_histories.minimum(:current_price)
  end

  def minimum_price_date(product)
    product.price_histories.order(current_price: :asc).first.created_at.strftime('%d/%m/%Y')
  end

  def maximum_price(product)
    product.price_histories.maximum(:current_price)
  end

  def maximum_price_date(product)
    product.price_histories.order(current_price: :desc).first.created_at.strftime('%d/%m/%Y')
  end

  def week_variation(product)
    week_price = (product.price_histories
                         .order(created_at: :asc)
                         .where('created_at >= ?', Time.zone.now - 1.week)
                         .first.current_price rescue nil)

    week_price.nil? ? 0.0 : (((product.price - week_price) * 100) / week_price).round(2)
  end

  def month_variation(product)
    month_price = (product.price_histories
                         .order(created_at: :asc)
                         .where('created_at >= ?', Time.zone.now - 1.month)
                         .first.current_price rescue nil)

    month_price.nil? ? 0.0 : (((product.price - month_price) * 100) / month_price).round(2)
  end

  def weekly_villains
    products = Product.where('week_variation < 200')
                      .where.not(market: Market.find_by(name: 'Carrefour'))
                      .order(week_variation: :desc)
                      .limit(10)
  end

  def weekly_heroes
    products = Product.where.not(market: Market.find_by(name: 'Carrefour'))
                      .order(week_variation: :asc)
                      .limit(10)
  end
end
