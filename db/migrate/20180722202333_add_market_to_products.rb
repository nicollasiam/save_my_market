class AddMarketToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :market, foreign_key: true
  end
end
