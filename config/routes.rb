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
    resources :projects
    resources :members do
      member do
        put 'sort'
      end
    end
    resources :projects do
      member do
        put 'sort'
      end
      resources :screenshots, only: [:create, :destroy] do
        put :sort, on: :collection
      end
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
  get "портфолио" => "home#portfolio"

  match "not-found" => "pages#not_found", via: [:get, :post], as: :not_found
  match ":shortlink" => "pages#showbyshortlink", via: [:get, :post]
  root 'home#index'
end
