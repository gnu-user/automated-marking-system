AutomatedMarkingSystem::Application.routes.draw do
  # Uncomment when enabling HTTPS
  # scope constraints: {protocol: 'https'}
  #resources :phone_book
  get 'login' => 'login#index'
  get 'login/new' => 'login#new'
  #resources :student
  root to: redirect('/login')
  #root 'student#index'
  get 'student' => 'student#index', :as => :student
  get 'student/:file' => 'student#show'
  get 'student/assignment/:id' => 'student#assignment'
  get 'student/grades/:id' => 'student#grading'
  get 'admin' => 'admin#index'
  get 'admin/new' => 'admin#new'
  get 'admin/grades/:id' => 'admin#grading'
  get 'admin/grades/:id/cheating' => 'admin#cheat'
  get 'admin/assignment/:id' => 'admin#show'

  #get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  #get "/500", :to => "errors#internal_error"

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
