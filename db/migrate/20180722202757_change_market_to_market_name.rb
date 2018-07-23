class ChangeMarketToMarketName < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :market, :market_name
  end
end
