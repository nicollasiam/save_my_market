class MarketsController < ApplicationController
  before_action :set_market, only: %i(show)

  def index
    @markets = Market.all
  end

  def show
    @market = Market.friendly.find(params[:id])
    get_products
  end

  private

  def set_market
    @market = Market.friendly.find(params[:id])
  end

  def get_products
    @products = @market.products.where("to_char(created_at, 'DD/MM/YYYY') > ?", Time.now.strftime('%d/%m/%Y'))
                       .order(:name).page params[:page]

    @products = @market.products.where("to_char(created_at, 'DD/MM/YYYY') > ?", (Time.now - 1.day).strftime('%d/%m/%Y'))
                       .order(:name).page params[:page] if @products.count.zero?
  end
end
