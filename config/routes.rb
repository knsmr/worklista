Worklista::Application.routes.draw do

  # OAuth callback point
  match "auth/:provider/callback" => "authentications#callback_handler"

  # Different ways to show user's item
  match "users/:username/popular" => "users#popular", :as => "user_popular", :via => "get"
  match "users/:username/pickup" => "users#pickup", :as => "user_pickup", :via => "get"
  match "users/:username" => "users#show", :as => "user_recent", :via => "get"
  match "users/:username/tag/:tag" => "users#tag", :as => "user_tag", :via => "get"

  # Export user's data
  match "/users/:username/export" => "users#export_xml"

  # Routes for items
  resources :users do
    resources :items
  end
  match "items/" => "items#index", :as => "item_index", :via => "get"
  match "tag/:tag" => "items#tag", :as => "tag", :via => "get"
  match "/users/:user_id/items/:id/toggle" => "items#toggle_pick", :as => "toggle_pick", :via => "put"

  # Routes for users and devise authentication
  match "/users" => "users#index"
  devise_for :users, :path => 'account', :controllers => {:registrations => "registrations"} do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
    get "account",   :to => "devise/registrations#edit"
  end
  
  # Static pages and the root
  root :to => "pages#home"
  match "/about" => "pages#about"
  match "/faq" => "pages#faq"

  # Error handling
  match '*a', :to => 'errors#routing'
end
