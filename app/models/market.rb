class Market < ApplicationRecord
  has_many :products, inverse_of: :market
end
