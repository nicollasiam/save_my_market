class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  paginates_per 20

  belongs_to :market, inverse_of: :products
  belongs_to :category, inverse_of: :products, optional: true
end
