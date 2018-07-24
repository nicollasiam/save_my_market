class AddSlugToMarket < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :slug, :string
  end
end
