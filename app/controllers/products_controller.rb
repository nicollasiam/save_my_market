class ProductsController < ApplicationController
  def search
    get_products
  end

  def show_search
  end

  def show
    @market = Market.friendly.find(params[:market_id])
    @product = Product.friendly.find(params[:id])

    @data = {
      labels: @product.price_histories.map(&:created_at),
      datasets: [
        {
          label: "My First dataset",
          background_color: "rgba(220,220,220,0.2)",
          border_color: "rgba(220,220,220,1)",
          data: @product.price_histories.map(&:current_price)
        }
      ]
    }
  end

  private

  def get_products
    @products = Product.where('lower(name) LIKE ?',
                              "%#{params[:search].downcase}%")

    @products_count = @products.count
    order_products if params[:sort]

    @products = @products.page params[:page]
  end

  def order_products
    @products = @products.joins(:price_histories).order('price_histories.current_price DESC') if params[:sort] == 'price_up'
    @products = @products.joins(:price_histories).order('price_histories.current_price ASC') if params[:sort] == 'price_down'
    @products.order!(name: :desc) if params[:sort] == 'name_up'
    @products.order!(name: :asc) if params[:sort] == 'name_down'
  end
end
