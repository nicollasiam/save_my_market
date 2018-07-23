class MarketsController < ApplicationController
  def index
    @markets = Market.all
  end

  def show
  end
end
