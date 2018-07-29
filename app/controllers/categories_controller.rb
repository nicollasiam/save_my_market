class CategoriesController < ApplicationController
  def show
    @market = Market.friendly.find(params[:market_id])
    @category = Category.friendly.find(params[:id])
    @all_categories = Category.all

    get_products
  end

  private

  def get_products
    @products = @products = @category.products.where(market: @market).order(:name, created_at: :desc)

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
