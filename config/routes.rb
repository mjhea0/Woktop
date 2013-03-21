Woktop::Application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  get 'profile', to: 'users#show', as: 'profile'
  get 'profile/edit', to: 'users#edit', as: 'editprofile'
  put 'profile/edit', to: 'users#update'
  
  resources :users
  resources :sessions
  
  root to: 'users#new'
end
