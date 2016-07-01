Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'nooks#index'
  resources :locations
  resources :reservations do
    collection do
      get :mine
    end
    member do
      patch :cancel
    end
  end

  resources :nooks, except: [:new, :edit, :create, :update, :destroy] do
    member do
      get :reserve
    end
    collection do
      get :search
      post :search
    end
  end

  get 'select_locations', to: 'locations#select', as: :select_locations

  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    get 'calendar', to: 'calendar#index'
    get 'welcome', to: 'welcome#index'

    get 'nook_statistics', to: 'nook_statistics#index'
    post 'nook_statistics/filter', to: 'nook_statistics#filter', as: :nook_stats_filter

    get 'reservation/:id/approve', to: 'reservations#approve', as: :reservation_approve
    get 'reservation/:id/reject', to: 'reservations#reject', as: :reservation_reject

    get 'nook/check_availability/:reservation_id', to: 'nooks#check_availability', as: :check_availability

    root controller: :welcome, action: :index
  end
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
end
