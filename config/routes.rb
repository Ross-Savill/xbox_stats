Rails.application.routes.draw do
  root to: 'stats#index'
  get '/stats', to: 'stats#index'
  get '/stats/:id', to: 'stats#show'
  get '/search' => 'stats#search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
