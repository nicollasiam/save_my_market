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
end
