class ProductsController < ApplicationController
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
end
