Rails.application.routes.draw do
  root 'tickets#index'
  resources :tickets
  resources :comments

  resources :profiles
  post 'profiles/:id', to: 'profiles#update'
  get 'users', to: redirect('/users/sign_up')
  get 'search', to: 'tickets#search'
  get 'export', to: 'tickets#export_to_csv'
# search_page_path
  devise_for :users
end
