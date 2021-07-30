Rails.application.routes.draw do
  get 'leaderboards/games_won', to: 'leaderboard#games_won', as: :games_won_leaderboard
  get 'go_fish/show'
  get 'go_fish/edit'
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

  get 'try_to_start_game/:game', to: 'games#start_game', as: 'try_to_start_game'

  resources :users
  resources :games
  resources :go_fish
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
