class PriceHistory < ApplicationRecord
  # default_scope { order(created_at: :asc) }

  belongs_to :product, inverse_of: :price_histories
end
