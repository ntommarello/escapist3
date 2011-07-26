Trek::Application.routes.draw do
  get "digest_emails/create"

  get "watched_plans/create"

  get "watched_plans/destroy"

  get "admin/index"

  get "dislikes/create"

  get "dislikes/destroy"

  get "likes/create"

  get "likes/destroy"

  get "comments/create"

  get "comments/destroy"

  get "authentications/index"

  get "authentications/create"

  get "authentications/destroy"

  get "blocks/create"
  get "blocks/destroy"

  get "subscribed_challenges/create"
  get "subscribed_challenges/destroy"


match '/auth/:provider/callback' =>'authentications#create'


  devise_for :users, :as => '', :path_names => { :sign_in => "login", :password => "reset_password" }, :controllers => { :sessions => 'sessions' } do
    get "/logout" => "devise/sessions#destroy"
    match "/api/login", :to => "sessions#create", :via => [:get, :post], :mobile => true
    
    get '/auth/:provider' => 'sessions#passthru'
    
    match '/auth/twitter/setup', :to => 'sessions#twitter_setup'
    match '/auth/facebook/setup', :to => 'sessions#fb_setup'

  end

  resources :users
  match 'confirm_email/:id' => 'users#confirm_email', :as => :confirm_email


  
  

   
  resources :challenges
  resources :admin
  resources :adventures, :controller => "challenges"
  
  match 'refresh_challenges' => 'challenges#refresh_challenges', :as => :refresh_challenges
  match 'geocoder' => 'challenges#geocoder', :as => :geocoder
  match 'geocode_plan' => 'plans#geocode_plan', :as => :geocode_plan
  
  
  
  match 'ajax_redraw_planning_box' => 'challenges#ajax_redraw_planning_box', :as => :ajax_redraw_planning_box
  
  resources :subscribed_challenges
  match 'bucket_list' => 'subscribed_challenges#bucket_list', :as => :bucket_list
  match 'panda_callback' => 'subscribed_challenges#panda_callback', :as => :panda_callback
  match 'regenerate_embed' => 'subscribed_challenges#regenerate_embed', :as => :regenerate_embed
  match 'add_note' => 'subscribed_challenges#add_note', :as => :add_note
 
  resources :messages
  match 'inbox' => 'messages#inbox', :as => :inbox
  match 'notifications' => 'messages#notifications', :as => :notifications
  match 'reply_message' => 'messages#reply_message', :as => :reply_message
  match 'no_cc' => 'messages#no_cc', :as => :no_cc
  
  resources :achievements
  resources :blocks
  resources :comments
  resources :likes
  resources :dislikes
  match '/plans/featured.:format', :controller => 'plans', :action => 'featured'
  resources :plans
  resources :escapes, :controller => "plans"
   match '/edit_plan_date', :controller => 'plans', :action => 'edit_plan_date'
  
  
  match 'my_escapes' => 'plans#my_escapes', :as => :my_escapes
  
  match "plans/:id", :controller => 'plans', :action => 'show', :via => [:get, :post]
  resources :digest_emails
  resources :subscribed_plans
  resources :watched_plans
  match 'initial_comment' => 'comments#initial_comment', :as => :initial_comment
  
  
  match 'spotlight' => 'web#spotlight', :as => :spotlight
  match 'spotlight2' => 'web#spotlight2', :as => :spotlight2
  match 'new_home' => 'web#new_home', :as => :new_home
  match 'live_search' => 'web#live_search', :as => :live_search
  match 'search' => 'web#search', :as => :search
  match 'refresh_spotlight' => 'web#refresh_spotlight', :as => :refresh_spotlight
  match 'rewards' => 'web#rewards', :as => :leaders
  match 'about' => 'web#about', :as => :about
  match 'jobs' => 'web#jobs', :as => :jobs
  match 'tos' => 'web#tos', :as => :tos
  match 'privacy_policy' => 'web#privacy_policy', :as => :privacy_policy
  match 'settings' => 'web#settings', :as => :settings
  match 'weeklyemail' => 'web#weeklyemail', :as => :weeklyemail
  
  match 'request' => 'city_requests#create', :via => :post
  match 'register' => 'users#register', :as => :register
  match 'my_challenges' => 'users#my_challenges', :as => :my_challenges
  match 'profile' => 'users#profile'
  match 'next_challenge', :controller => "web", :action=>"next_challenge"
  match 'refresh_container', :controller => "web", :action=>"refresh_container"
  match 'new_refresh_container', :controller => "web", :action=>"new_refresh_container"

  match 'create_search_results', :controller => "challenges", :action=>"create_search_results"
  match 'achievement_live_results', :controller => "achievements", :action=>"achievement_live_results"
  
  match 'confirmation', :controller => 'plans', :action => 'confirmation'
  match 'wepay_callback', :controller => 'plans', :action => 'wepay_callback'
   match 'paypal_ipn', :controller => 'plans', :action => 'paypal_ipn'
  match 'schedule', :controller => 'plans', :action => 'schedule'
  
  
  match 'create', :controller => 'web', :action => 'apply'
  match 'host_an_adventure', :controller => 'web', :action => 'host_an_adventure'
 
  
  match 'upgrade_browser', :controller => 'web', :action => 'upgrade_browser'
  match ':username', :controller => 'users', :action => 'show'
  
  
  
  # API - Users
  # match 'api/login', :controller => 'users', :action => 'mobile_login', :via => [:get, :post]
  match 'api/register', :controller => 'users', :action => 'mobile_create', :via => [:get, :post]
  match 'api/users/:id.:format', :controller => 'users', :action => 'show'
  match 'api/scan_addressbook.:format', :controller => 'users', :action => 'scan_addressbook'
  match 'api/invite.:format', :controller => 'users', :action => 'invite'
  match 'api/mobile_livesearch.:format', :controller => 'challenges', :action => 'mobile_livesearch'
  
  root :to => "web#new_home"
end
