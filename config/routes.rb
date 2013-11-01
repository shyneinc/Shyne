require 'api_constraints'

Shyne::Application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/admin', to: redirect('/active_admin')
  mount Raddocs::App => "/docs"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
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
      end

      resources :users, only: [:create]
      match '/users' => 'users#show', :via => :get
      match '/users' => 'users#update', :via => :put

      resources :mentors, except: [:update, :destroy] do 
        resources :work_histories
      end
      match '/mentors' => 'mentors#update', :via => :put
      match '/mentors' => 'mentors#destroy', :via => :delete

      resources :members, except: [:update, :destroy]
      match '/members' => 'members#update', :via => :put
      match '/members' => 'members#destroy', :via => :delete

      resources :industries, only: [:index]

      resources :calls, except: [:index]

      resources :search, only: [:index]

      match '/conference' => 'conference#index' , via: :get, defaults: {format: :xml}
      match '/conference/initiate' => 'conference#initiate' , via: :get, defaults: {format: :xml}
      match '/conference/save' => 'conference#save' , via: :post, defaults: {format: :xml}
    end
  end


end

