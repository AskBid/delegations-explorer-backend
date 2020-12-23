Rails.application.routes.draw do
  resources :users, only: [:create] do
  	resources :stakes, only: [:index, :create]
  	resources :pools, only: [:create, :index]
  	resources :active_stake, only: [:index]
  end
  get 'login', to: 'sessions#restore'
  get 'epoch', to: 'epoch#info'
end