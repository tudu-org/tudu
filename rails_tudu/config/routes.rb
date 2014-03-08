Tudu::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  # You can have the root of your site routed with "root"
  

  # get "users" => "users#index" #remove in prod
  # get "new_user" => "users#new"
  # post "new_user" => "users#create"
  
  controller :sessions do
     get 'login' => :new
     post 'login' => :create
     delete 'logout' => :destroy
  end
  get "/" => "sessions#new"
  
  get "sessions/create"
  get "sessions/destroy"

  resources :users do
    get "schedule"
    collection do
      get "by_email"
    end

    resources :events do
      collection do
        get "in_range"
      end
    end

    resources :tasks do
      collection do
        post "schedule"
      end
    end

    resources :recurring_events
  end

  get "home" => "home#index"
  get "task" => "home#task"

  resources :calendar
  resources :events

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
