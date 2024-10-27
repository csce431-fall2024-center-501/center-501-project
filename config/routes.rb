# frozen_string_literal: true

Rails.application.routes.draw do
  get '/projects/new', to: 'projects#new', as: 'new_project'
  post '/projects/new', to: 'projects#new', as: 'new_preview'
  post '/projects/:id/preview', to: 'projects#preview', as: 'preview'

  get '/calendars', to: 'calendar#calendars', as: 'calendars'
  get '/events/:calendar_id', to: 'calendar#events', as: 'events', calendar_id: %r{[^/]+}
  post '/events/:calendar_id', to: 'calendar#new_event', as: 'new_event', calendar_id: %r{[^/]+}

  get '/emails', to: 'emails#email', as: 'email'
  get '/emails/indiviual_email', to: 'emails#individual_email', as: 'individual_email'
  get '/emails/active_member_email', to: 'emails#active_member_email', as: 'active_member_email'
  get '/emails/active_inactive_member_email', to: 'emails#active_inactive_member_email',
                                              as: 'active_inactive_member_email'
  post '/emails', to: 'emails#send_email', as: 'send_email'
  post '/emails/active_member_email', to: 'emails#send_active_member_email', as: 'send_active_member_email'
  post '/emails/active_inactive_member_email', to: 'emails#send_active_inactive_member_email',
                                               as: 'send_active_inactive_member_email'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  resources :locations do
    member do
      get :delete
    end
  end

  resources :photos do
    member do
      get :delete
    end
  end

  resources :users do
    collection do
      get 'complete_profile'
      patch 'update_profile'
    end
    member do
      get :delete
    end
  end

  resources :educations

  resources :projects do
    member do
      get :delete
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :sponsorships do
    member do
      get :delete
    end
  end
  root 'pages#home'
end
