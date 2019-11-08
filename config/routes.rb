Rails.application.routes.draw do
  root 'tickets#index'
  resources :tickets
  resources :comments

  resources :profiles
  post 'profiles/:id', to: 'profiles#update'

  devise_for :users
end
