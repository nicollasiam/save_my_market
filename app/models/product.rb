class Product < ApplicationRecord
  belongs_to :market, inverse_of: :products
end
