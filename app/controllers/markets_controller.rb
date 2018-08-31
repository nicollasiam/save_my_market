class MarketsController < ApplicationController
  before_action :set_market, only: %i(show)
  before_action :set_categories

  def index
    @markets = Market.all
  end

  def show
    get_products
  end

  private

  def set_market
    @market = Market.friendly.find(params[:id])
  end

  def set_categories
    @all_categories = Category.all
  end

  def get_products
    @products = @market.products.available

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
