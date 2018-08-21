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
      labels: @product.price_histories.map { |date| date.created_at.strftime('%d/%m/%Y') },
      datasets: [
        {
          label: "Preços",
          background_color: "rgba(220,220,220,0.2)",
          border_color: "rgba(220,220,220,1)",
          data: @product.price_histories.map(&:current_price)
        }
      ]
    }

    @options = {
      lineTension: 0,
      pointRadius: 2,
      pointBackgroundColor: '#ffa500'
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
    @products = @products.order(price: :desc) if params[:sort] == 'price_up'
    @products = @products.order(price: :asc) if params[:sort] == 'price_down'
    @products.order!(name: :desc) if params[:sort] == 'name_up'
    @products.order!(name: :asc) if params[:sort] == 'name_down'
  end
end
