class ApplicationController < ActionController::Base
  require 'koala'
 require 'uri'
 require 'valid_browser'
 include ValidBrowser
 
 
 before_filter :check_group
  before_filter :browser_detect
  
  before_filter :locate_user

  

  def check_group
    
    @wepay_token = "a8a520ec65"
    @wepay_group_id = "11377"
    
    
    @fb_id = FACEBOOK_APP_ID
    @fb_secret = FACEBOOK_SECRET
    @source = APP_URL

    @domain = URI.parse(request.url).host
      
    if @domain.include? "startupworkaway"
      @group = Group.find(1)
      @fb_id = @group.fb_id
      @fb_secret = @group.fb_secret
      @source = @group.url
    end
    if @domain.include? "tropicaljobhunt"
      @group = Group.find(2)
      @fb_id = @group.fb_id
      @fb_secret = @group.fb_secret
      @source = @group.url
    end
    if @domain.include? "connectorcampfire"
      @group = Group.find(3)
      @fb_id = @group.fb_id
      @fb_secret = @group.fb_secret
      @source = @group.url
    end
    if @group
      if @group.wepay_token.length > 0
        @wepay_token = @group.wepay_token
      end
      if @group.wepay_group_id.length > 0
        @wepay_group_id = @group.wepay_group_id
      end
    end
    
    #@group = Group.find(3)
    
    #dev
    #@fb_id = "164081146992153";
    #@fb_secret = "55a03475946d67b6f761c48da2f59cbe";

  
    
  end


  def browser_detect
    #Brute force hack.  For ajax back button stuff. Otherwise stale content loaded.
    
    #response.headers['Cache-Control'] = 'no-store'
    #response.headers['Vary'] = '*'
    

    
    
    
    @browser = Browser.new(:ua => request.env["HTTP_USER_AGENT"], :accept_language => "en-us")
    @user_agent = UserAgent.parse(request.user_agent)
    
    unless is_bot?(request)
      unless params[:action] == "upgrade_browser"
       unless valid_browser?
        redirect_to '/upgrade_browser'
       end
      end
    end
      
  end
  
  protected
  
  def login_from_token
    if params[:auto_login_token]
      user = User.find_by_authentication_token(params[:auto_login_token])
      sign_in(user) if user
    end 
  end

  def check_cookies 
  end

  def add_challenges_from_cookie(challenges, authored = false)
  end
  
  
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) 
    
      location = request.env["HTTP_REFERER"] || root_path
      if location.match(/#{register_path}/)
         root_path
      else
         location
      end
    else
      super
    end
  end
  
  
  def after_sign_out_path_for(resource_or_scope)
      location = request.env["HTTP_REFERER"] || root_path
  end
  
  
  def set_city_dropdown(location)
    calc_closest_city(location)
    session[:dropdown_city] = @returned_city_name 
    session[:dropdown_city_value] =  @returned_city_id 
    
  end
  

  def calc_closest_city(loc)
    
    boston = loc.distance_to([42.358431,-71.059773])
    new_york = loc.distance_to([40.7144,-74.006])
    san_fran = loc.distance_to([37.77493,-122.419416])

    @returned_city_id = "99"
    @returned_city_name = "Luxury"
    if boston < 200
       if boston < new_york
         @returned_city_id = "1"
         @returned_city_name = "Boston"
       end
    end

    if new_york < 200
       if new_york < boston
         @returned_city_id = "3"
         @returned_city_name = "New York City"
       end
    end

    if san_fran < 200
       @returned_city_id = "2"
       @returned_city_name = "San Francisco"
    end
    
  end



  def locate_user
		if current_user 
		  if session[:location_city].nil?
		    session[:lat] = current_user.lat
  		  session[:lng] = current_user.lng
  		  session[:location_city] = current_user.location_city
  		end
  		if session[:dropdown_city].nil?
  		  set_city_dropdown(current_user)
  		end
	  else
	    if session[:location_city].nil?
	  	  location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
        if location.lat
          session[:location_city] = "#{location.city} #{location.state}"
          session[:lat] = location.lat
          session[:lng] = location.lng
          set_city_dropdown(location)
        else
          session[:location_city] = "Boston MA"
          session[:lat] = 42.3584
          session[:lng] = -71.0598
          session[:dropdown_city] = "Boston"
          session[:dropdown_city_value] = "1"
        end
      end
    end
	end
	
	def generate_password(length=6)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'
    password = ''
    length.times { |i| password << chars[rand(chars.length)] }
    password
  end
  
  def is_bot?(request)
  
    agent = request.env["HTTP_USER_AGENT"]
    matches = nil
    matches = agent.match(/(facebook|postrank|voyager|twitterbot|googlebot|slurp|butterfly|pycurl|tweetmemebot|metauri|evrinid|reddit|digg)/mi) if agent
    if ( agent.nil? or matches)
       return true

     else
       return false
    end
  end
	
  
  
end
