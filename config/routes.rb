Rails.application.routes.draw do
  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about',to: 'static_pages#about'
  get '/contacts', to: 'static_pages#contacts'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/signup', to: 'users#new'
  get '/personal', to: 'users#show'
  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
