class MarketsController < ApplicationController
  before_action :set_market, only: %i(show)

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

  def get_products
    @products = Product.where("to_char(created_at, 'DD/MM/YYYY') > ? AND market_id = ?", Time.now.strftime('%d/%m/%Y'), @market.id)
    @products = Product.where("to_char(created_at, 'DD/MM/YYYY') > ? AND market_id = ?", (Time.now - 1.day).strftime('%d/%m/%Y'), @market.id) if @products.count.zero?
  end
end
