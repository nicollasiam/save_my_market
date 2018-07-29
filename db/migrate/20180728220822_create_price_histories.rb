class CreatePriceHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :price_histories do |t|
      t.float :old_price
      t.float :current_price

      t.timestamps
    end
  end
end
