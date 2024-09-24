# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :projects do
    member do
      get :delete
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
