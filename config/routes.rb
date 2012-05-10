Ec::Application.routes.draw do

  resources :password_resets
  resources :comments

  resources :events

  match "/account" => "users#account"
  match "/password_mail_sent" =>"info#password_mail_sent_notice"
  match "/settings/profile" =>"users#edit", :as => "set_profile"
  match "/all_events" => "events#all_events"
  match "/all_updates" => "comments#all_updates"
  match "/about" => "info#about"
  match "/about/location" => "info#location"
  match "/about/people" => "info#people" # this used to be "users#index"
  match "/login" =>"users#login", :as => "login"
  match "/user_auth" =>"users#auth"
  match "/new_mail" =>"users#newmail" 
  match "/send_mail" =>"users#sendmail" 
  get "logout" => "users#logout", :as => "logout"  
  get "sign_up" => "users#new", :as => "sign_up"  
  match "/forget_password" =>"password_resets#new", :as => "forget_password"

  root :to => "events#index"  
  resources :users
  resources :sessions
  resources :events do
    resources :comments
  end
  resources :users do
    resources :comments
  end
  resources :comments ## will this confilcts with about nested one

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
