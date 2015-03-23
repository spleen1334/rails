LyndaCms::Application.routes.draw do

  # REST ROUTES, ima i dole u komentarima
  resources :subjects do
    member do
      get :delete # zato sto nije ukljucen po default
    end
  end

  # Default route structure:
  # :controller/:action/:id

  # DEFAULT ROUTE:
  # Ovo ucitava AUTO sve parametre
  # Ovo se nekad zvalo default route, sad se nekoristi:
  match ':controller(/:action(/:id))', via: [:get, :post]

  # ROOT ROUTE:
  # Good practise je da root stoji na dnu kao last
  # Jer se route procesira top > bottom
  # root to: 'demo#index'
  # root 'demo#index' # shorthand
  root 'public#index'

  # sve show/asdf salje na public#show
  get 'show/:permalink', :to => 'public#show'


  # Admin access
  get 'admin', :to => 'access#index'

  # GET ROUTE
  # get 'demo/index'

  # GET JE SHORTHAND ZA:
  # match "demo/index",
  #   to: "demo#index",
  #   :via => [:get, :post]

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
end
