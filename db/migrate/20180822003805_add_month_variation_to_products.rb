class AddMonthVariationToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :month_variation, :decimal, precision: 10, scale: 2
  end
end
