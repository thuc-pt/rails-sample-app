Rails.application.routes.draw do
  scope "(:locale)" do
    root "static_pages#home"

    get "about" => "static_pages#about"
    get "contact" => "static_pages#contact"
    get "help" => "static_pages#help"
    get "signin" => "sessions#new"
    post "signin" => "sessions#create"
    get "signout" => "sessions#destroy"
    get "signup" => "users#new"
    resources :users, except: :new do
      resources :followings, :followers, only: :index
    end
    get "reset/password" => "password_resets#new"
    post "reset/password" => "password_resets#create"
    resources :microposts, except: [:index, :show, :new]
    resources :relationships, only: [:create, :destroy]
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: [:edit, :update]
end
