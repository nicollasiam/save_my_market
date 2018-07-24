class Market < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products, inverse_of: :market
end
