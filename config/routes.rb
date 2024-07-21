Rails.application.routes.draw do
  root 'home#index'
  get 'users', to: 'users#index'
  get "error", to: "home#error"
  # root 'users#index'  # Hace que la página de inicio sea la lista de usuarios
end
