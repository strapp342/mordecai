Rails.application.routes.draw do
  get 'nfldata/index'

  root 'nfldata#index'

  resources :nflgames

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
