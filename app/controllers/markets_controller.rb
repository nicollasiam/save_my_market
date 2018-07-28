class MarketsController < ApplicationController
  before_action :set_market, only: %i(show)

  def index
    @markets = Market.all
  end

  def show
    @market = Market.friendly.find(params[:id])
    @category = Category.all
    get_products
  end

  private

  def set_market
    @market = Market.friendly.find(params[:id])
  end

  def get_products
    @products = @market.products.where("to_char(created_at, 'DD/MM/YYYY') > ?", Time.now.strftime('%d/%m/%Y'))

    @products = @market.products.where("to_char(created_at, 'DD/MM/YYYY') > ?", (Time.now - 1.day).strftime('%d/%m/%Y')) if @products.count.zero?

    @products_count = @products.count
    order_products if params[:sort]

    @products = @products.order(:name).page params[:page]
  end

  def order_products
    @products.order!(price: :desc) if params[:sort] == 'price_up'
    @products.order!(price: :asc) if params[:sort] == 'price_down'
    @products.order!(name: :desc) if params[:sort] == 'name_up'
    @products.order!(name: :asc) if params[:sort] == 'name_down'
  end
end
