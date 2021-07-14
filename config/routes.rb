Rails.application.routes.draw do
  #get 'game_user/create'
  # get 'games/index'
  # get 'games/show'
  # get 'games/new'
  root 'static_pages#home'
  get 'static_pages/home'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'signup', to: 'users#new'
  get '/styleguide', to: 'styleguide#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'game_users', to: 'game_user#create'
  post 'game_user/create'
  resources :users
  resources :games
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
