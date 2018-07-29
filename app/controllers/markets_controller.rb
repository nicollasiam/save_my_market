class MarketsController < ApplicationController
  before_action :set_market, only: %i(show)

  def index
    @markets = Market.all
  end

  def show
    @category = Category.all
    get_products
  end

  private

  def set_market
    @market = Market.friendly.find(params[:id])
  end

  def get_products
    @products = @market.products

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
