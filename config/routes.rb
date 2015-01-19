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
    resources :teammates
    resources :technologies
    resources :technology_groups do
      resources :technologies
    end
    root :to => "home#index"
  end

  get "home/index", as: 'main'
  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"

  match "not-found" => "pages#not_found", via: [:get, :post], as: :not_found
  match ":shortlink" => "pages#showbyshortlink", via: [:get, :post]
  root 'home#index'
end
