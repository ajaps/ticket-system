Rails.application.routes.draw do
  root 'tickets#index'
  resources :tickets
  resources :comments
  devise_for :users
end
