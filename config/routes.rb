Woktop::Application.routes.draw do
  resources :users
  resources :sessions
  resources :dropbox_users
  resources :dropbox_files
  
  get 'signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'
  get 'profile', to: 'users#show', as: 'profile'
  get 'profile/edit', to: 'users#edit', as: 'editprofile'
  put 'profile/edit', to: 'users#update'
  
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  
  get 'dropbox/new', to: 'dropbox_users#authorize', as: 'dropboxAuth'
  get 'dropbox/files/get', to: 'dropbox_users#getFiles', as: 'dropboxGetFiles'
  get 'dropbox/accounts/get', to: 'dropbox_users#getAccount', as: 'dropboxGetAccount'
  get 'dropbox/accounts/update', to: 'dropbox_users#updateAccount', as: 'dropboxUpdateAccount'
  put 'dropbox/accounts/update', to: 'dropbox_users#updateAccount'
  get 'dropbox/accounts/delete', to: 'dropbox_users#removeAccount', as: 'dropboxRemoveAccount'
  
  get 'dropbox/files/delete', to: 'dropbox_files#removeFiles', as: 'dropboxRemoveFiles'
   
  root to: 'users#new'
end
