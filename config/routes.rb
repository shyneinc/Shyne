require 'api_constraints'

Shyne::Application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/admin', to: redirect('/active_admin')

  authenticate(:admin) do
    mount Raddocs::App => "/docs"
    match "/delayed_job" => DelayedJobWeb, :via => :get, :anchor => false
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :home, only: [:index]
  root :to => "home#index"
  devise_for :users

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      devise_scope :user do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions' => 'sessions#destroy', :via => :delete

        match '/confirmations' => 'confirmations#create', :via => :post
        match '/confirmations' => 'confirmations#show', :via => :get

        match '/passwords' => 'passwords#create', :via => :post
        match '/passwords' => 'passwords#update', :via => :put


        match '/update_password' => 'passwords#update_password', :via => :put
      end

      resources :users, only: [:create]
      match '/users' => 'users#show', :via => :get
      match '/users' => 'users#update', :via => :put

      resources :mentors, except: [:update, :destroy] do
        resources :work_histories
        resources :reviews
      end
      match '/mentors' => 'mentors#update', :via => :put
      match '/mentors' => 'mentors#destroy', :via => :delete
      match '/all_mentors' => 'mentors#all_mentors', :via => :get

      resources :members, except: [:update, :destroy]
      match '/members' => 'members#update', :via => :put
      match '/members' => 'members#destroy', :via => :delete

      resources :industries, only: [:index]

      resources :call_requests, except: [:show]

      resources :search, only: [:index]

      resources :credit_cards, except: [:update]

      resources :bank_accounts, except: [:update]

      resources :conversations

      match '/payment_transactions' => 'payment_transactions#index', :via => :post

      match '/call/initiate' => 'call#initiate', via: :post, defaults: {format: :xml}
      match '/call/start' => 'call#start', via: :post, defaults: {format: :xml}
      match '/call/finish' => 'call#finish', via: :post, defaults: {format: :xml}
    end
  end

end

