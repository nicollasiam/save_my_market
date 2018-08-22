class AddWeekVariationToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :week_variation, :decimal, precision: 10, scale: 2
  end
end
