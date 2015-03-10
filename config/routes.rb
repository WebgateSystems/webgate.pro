WebgatePro::Application.routes.draw do

  resources :sessions

  namespace :admin do
    resources :users
    resources :categories do
      collection do
        post 'sort'
      end
    end
    resources :pages
    resources :members do
      member do
        put 'sort'
      end
    end
    resources :projects do
      put :update_position, on: :collection
      member do
        put 'sort'
      end
      resources :screenshots
    end
    resources :technologies
    resources :technology_groups do
      resources :technologies
    end
    root :to => "home#index"
  end

  get "home/index", as: 'main'
  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "team" => "team#index"
  get "team/:id" => "team#show", as: "member"
  get "portfolio" => "home#portfolio"

  match "not-found" => "pages#not_found", via: [:get, :post], as: :not_found
  match ":shortlink" => "pages#showbyshortlink", via: [:get, :post]
  root 'home#index'
end
