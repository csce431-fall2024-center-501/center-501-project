# frozen_string_literal: true

Rails.application.routes.draw do
  get '/redirect', to: 'calendar#redirect', as: 'redirect'
  get '/callback', to: 'calendar#callback', as: 'callback'
  get '/calendars', to: 'calendar#calendars', as: 'calendars'
  get '/events/:calendar_id', to: 'calendar#events', as: 'events', calendar_id: %r{[^/]+}
  post '/events/:calendar_id', to: 'calendar#new_event', as: 'new_event', calendar_id: %r{[^/]+}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
