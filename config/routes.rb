Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "v/:version_number/:klass_name/:section", to: "sections#show_redirect", as: :section_redirect, :version_number => /\d(\.\d){1,2}/
  get "v/:version_number/:klass_name", to: "klasses#show_redirect", as: :klass_redirect, :version_number => /\d(\.\d){1,2}/
  get "v/:version_number", to: "versions#show_redirect", as: :version_redirect, :version_number => /\d(\.\d){1,2}/
  get "search", to: "search#search", as: :search

  resources :versions do
    member do
      get :main_classes
      get :all_classes
    end
    resources :klasses, only: [:new, :create]
  end
  resources :klasses, only: [:show, :edit, :update, :destroy] do
    member do
      get :instance_methods
      get :class_methods
    end
    resources :sections, only: [:new, :create]
  end
  resources :sections, only: [:show, :edit, :update, :destroy]

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
