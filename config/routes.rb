Rails.application.routes.draw do
  resources :users, only: [:create] do
  	resources :stakes, only: [:index, :create]
  end
  get 'login', to: 'sessions#restore'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
