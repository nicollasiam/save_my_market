class AddAvailabilityToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :availability, :boolean, default: true
  end
end
