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
        #put :update_position, on: :collection
      end
    end
    root :to => "home#index"
  end

  get "home/index", as: 'main'
  get "logout" => "sessions#destroy", as: "logout"
  get "login" => "sessions#new", as: "login"
  get "team" => "home#team"
  get "praca" => "home#team"
  get "команда" => "home#team"
  get "portfolio" => "home#portfolio"
  get "портфолио" => "home#portfolio"

  match "not-found" => "pages#not_found", via: [:get, :post], as: :not_found
  match ":shortlink" => "pages#showbyshortlink", via: [:get, :post]
  root 'home#index'
end
