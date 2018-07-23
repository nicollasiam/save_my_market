class CreateMarkets < ActiveRecord::Migration[5.2]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :logo

      t.timestamps
    end
  end
end
