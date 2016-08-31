Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions",  registrations: "registrations"}

  root "home#index", as: "landing_page"

  authenticated :user do
    root "reports#index"
  end

  resources :agencies
  resources :reports
  resources :validations, only: [:new, :create]

  namespace :admin do
    resources :users, controller: "users"
  end

  get "/search", to: "reports#search", as: "search_reports"
  get "/export", to: "reports#export", as: "export_reports"
  get "/reports/:id/validate", to: "reports#validate", as: "validate_report"
  get "/reports/:id/summary", to: "reports#summary", as: "report_summary"
  get "/reports/:id/lock", to: "reports#lock", as: "lock_report"
  get "/validations/thank_you", to: "validations#thank_you", as: "validation_thank_you"
  get "/report_submitted/thank_you", to: "reports#thank_you", as: "report_thank_you"

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
