Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :registrations, only: %i[create]
      resources :sessions, only: %i[create]
      resources :orders, only: %i[index]
    end
  end
end
