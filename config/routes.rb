Rails.application.routes.draw do
  root to: 'markets#index'

  resources :markets, only: %i(index show) do
    resources :products, only: :show
    resources :categories, only: :show
  end
end
