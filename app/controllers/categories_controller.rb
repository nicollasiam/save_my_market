class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:id])
    @all_categories = Category.all

    get_market_category_products unless params[:market_id].eql?('0')
    get_category_products if params[:market_id].eql?('0')

    @products_count = @products.count
    order_products if params[:sort]

    @products = @products.page params[:page]
  end

  private

  def get_market_category_products
    @market = Market.friendly.find(params[:market_id])
    @products = @category.products.available.where(market: @market)
  end

  def get_category_products
    @market = '0'
    @products = @category.products.available
  end

  def order_products
    @products = @products.order(price: :desc) if params[:sort] == 'price_up'
    @products = @products.order(price: :asc) if params[:sort] == 'price_down'
    @products.order!(name: :desc) if params[:sort] == 'name_up'
    @products.order!(name: :asc) if params[:sort] == 'name_down'
  end
end
