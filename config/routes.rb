WebgatePro::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  resources :sessions

  namespace :admin do
    resources :users
    resources :categories do
      put :update_position, on: :collection
    end
    resources :pages
    resources :members do
      put :update_position, on: :collection
      member do
        put 'sort_member_links'
        put 'sort_technologies'
      end
    end
    resources :projects do
      put :update_position, on: :collection
      member do
        put 'sort_screenshots'
      end
      resources :screenshots
    end
    resources :technologies
    resources :technology_groups do
      put :update_position, on: :collection
      member do
        put 'sort_technologies'
      end
      resources :technologies do
      end
    end
    root :to => "home#index"
  end

  localized do
    get 'main',         to: 'home#index', as: :main
    match 'not-found',  to: 'pages#not_found', via: [:get, :post], as: :not_found
    get 'portfolio',    to: 'home#portfolio', as: :portfolio
    get 'team',         to: 'home#team', as: :team
  end

  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"

  get ":shortlink" => "pages#showbyshortlink"
  root to: 'home#index'
end
