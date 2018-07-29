class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  paginates_per 18

  belongs_to :market, inverse_of: :products
  belongs_to :category, inverse_of: :products, optional: true

  has_many :price_histories, inverse_of: :product, dependent: :destroy
end
