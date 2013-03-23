Woktop::Application.routes.draw do
  resources :users
  resources :sessions
  resources :dropbox_users
  
  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'
  get 'profile', to: 'users#show', as: 'profile'
  get 'profile/edit', to: 'users#edit', as: 'editprofile'
  put 'profile/edit', to: 'users#update'
  
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  
  get 'dropbox/new', to: 'dropbox_users#authorize', as: 'dropboxAuth'
   
  root to: 'users#new'
end
