Rails.application.routes.draw do
  get 'nflplayers/index'

  get 'nflplayers/show'

  get 'nflteams/index'

  get 'nflteams/show'

  get 'nfldata/index'

  root 'nfldata#index'

  resources :nflgames

  resources :nflteams

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
