class ProductsController < ApplicationController
  def search
    get_products
  end

  def show_search
  end

  def show
    @market = Market.friendly.find(params[:market_id])
    @product = Product.friendly.find(params[:id])

    @data = @product.price_histories.order(created_at: :asc)
                    .map { |data| [data.created_at.strftime('%d/%m/%Y'),
                                   data.current_price] }
  end

  private

  def get_products
    @products = Product.available
                       .where('lower(name) LIKE ?',
                              "%#{params[:search].downcase}%")

    @products_count = @products.count
    order_products if params[:sort]

    @products = @products.page params[:page]
  end

  def order_products
    @products = @products.order(price: :desc) if params[:sort] == 'price_up'
    @products = @products.order(price: :asc) if params[:sort] == 'price_down'
    @products.order!(name: :desc) if params[:sort] == 'name_up'
    @products.order!(name: :asc) if params[:sort] == 'name_down'
  end
end
