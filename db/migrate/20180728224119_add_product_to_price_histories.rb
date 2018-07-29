class AddProductToPriceHistories < ActiveRecord::Migration[5.2]
  def change
    add_reference :price_histories, :product, foreign_key: true
  end
end
