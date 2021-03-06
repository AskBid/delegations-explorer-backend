Rails.application.routes.draw do
  resources :users, only: [:create] do
  	resources :stakes, only: [:index, :create, :destroy]
  	resources :pools, only: [:create, :index, :destroy]
  	resources :active_stake, only: [:index]
  end
  resources :pools, only: [:index]
  get 'login', to: 'sessions#restore'
  get 'epoch', to: 'epoch#info'
end