Rails.application.routes.draw do
  get 'users/new'
  get '/styleguide', to: 'styleguide#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
