Rails.application.routes.draw do
  get 'users', to: 'users#index'
  root 'users#index'  # Hace que la página de inicio sea la lista de usuarios
end
