Rails.application.routes.draw do
  root to: 'markets#index'

  resources :markets, only: %i(index, show)
  resources :products, only: :show
end
