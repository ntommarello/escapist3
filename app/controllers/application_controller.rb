class ApplicationController < ActionController::Base
  require 'koala'
 require 'uri'
 require 'valid_browser'
 include ValidBrowser
 
 
  before_filter :check_group
  before_filter :browser_detect
  
  before_filter :locate_user
#before_filter :find_active_cities
  

  def check_group  
    
    @snowriders = "(46,53,54,55)"
    
    @fb_id = FACEBOOK_APP_ID
    @fb_secret = FACEBOOK_SECRET
    @source = APP_URL

    @domain = URI.parse(request.url).host
    
    @domain = @domain.sub( "www.", "" )
    
     if Rails.env == "development"
       @domain = "techcoparty.com"
    end
    
    if @domain != APP_URL and @domain != "localhost:3000"
      test = Group.find_by_url(@domain)
      if test
        @group = test
        @fb_id = test.fb_id
        @fb_secret = test.fb_secret
        @source = test.url
      else
        if request.subdomains.first
          test2 = Group.find_by_username(request.subdomains.first)
          if test2
            @group = test2
            @fb_id = test2.fb_id
            @fb_secret = test2.fb_secret
            @source = test2.url
          else
            redirect_to "http://#{APP_URL}"
          end
        end
      end
    end
  end


  def browser_detect
    #Brute force hack.  For ajax back button stuff. Otherwise stale content loaded.
    
    #response.headers['Cache-Control'] = 'no-store'
    #response.headers['Vary'] = '*'
  
    
    
    
    @browser = Browser.new(:ua => request.env["HTTP_USER_AGENT"], :accept_language => "en-us")
    @user_agent = UserAgent.parse(request.user_agent)
    
    @old_browser = false
    #unless is_bot?(request)
      #unless params[:action] == "upgrade_browser"
       unless valid_browser?
         @old_browser = true
       end
      #end
    #end

  end
  
  protected
  
  def login_from_token
    if params[:auto_login_token]
      user = User.find_by_authentication_token(params[:auto_login_token])
      sign_in(user) if user
    end 
  end

  def check_cookies 
    
    if session[:refer_id]
      @user.referred_by = session[:refer_id]
      @user.discount_active = true
      session[:refer_id] = nil
      @user.save
    end
    
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
    @returned_city_name = "World Travel"
    
    if boston < 200
       if boston < new_york
         @returned_city_id = "1"
         @returned_city_name = "Boston"
       end
    end
    

    
    
    #TODO:  Make Dynamic Based on if Content in City

    #if new_york < 200
    #   if new_york < boston
    #     @returned_city_id = "3"
     #    @returned_city_name = "New York City"
     #  end
    #end

    #if san_fran < 200
    #   @returned_city_id = "2"
    #   @returned_city_name = "San Francisco"
    #end
    
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
	      if request.remote_ip
	  	    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)

          if location.lat
            session[:location_city] = "#{location.city} #{location.state}"
            session[:lat] = location.lat
            session[:lng] = location.lng
            set_city_dropdown(location)
          else
            session[:location_city] = "Unknown"
            session[:lat] = 0
            session[:lng] = 0
            session[:dropdown_city] = "World Travel"
            session[:dropdown_city_value] = "99"
          end
        else
          session[:location_city] = "Unknown"
          session[:lat] = 0
          session[:lng] = 0
          session[:dropdown_city] = "World Travel"
          session[:dropdown_city_value] = "99"
          
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
	
	
	
	
	def remove_end_breaks(text)  
       if text != nil and text != ""
           text.strip!

           index = text.rindex("<br>")

           while index != nil and index == text.length - 4
               text = text[0, text.length - 4]

               text.strip!

               index = text.rindex("<br>")
           end

           text.strip!

           index = text.index("<br>")

           while index != nil and index == 0
               text = test[4, text.length]

               text.strip!

               index = text.index("<br>")
           end
       end

       return text
   end
   
  
  
  def find_active_cities
    
    t = Time.zone.now
    rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
    
    @ny_active = false
    ny_plans = Plan.find(:first, :conditions=>["city_id=3 and start_time >= ?",rounded_t])
    if ny_plans
      @ny_active = true
    end
    
    @boston_active = false
    boston_plans = Plan.find(:first, :conditions=>["city_id=1 and start_time >= ?",rounded_t])
    if boston_plans
      @boston_active = true
    end
    
    @sf_active = false
    sf_plans = Plan.find(:first, :conditions=>["city_id=2 and start_time >= ?",rounded_t])
    if sf_plans
      @sf_active = true
    end

  end
  
  
  
  def sign_up_plan
       if params[:maybe]
          @maybe = params[:maybe]
        else
          @maybe = 0
        end

         check = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
         if check
           check.maybe = @maybe
           check.save!
         else
            
            @subscribed = SubscribedPlan.new
            @subscribed.plan_id = params[:plan_id]
            @subscribed.user_id = current_user.id
             @subscribed.save!
             
            #SubscribedPlan.create(:plan_id => params[:plan_id], :user_id=>current_user.id, :maybe=>@maybe)

            @plan = Plan.find(params[:plan_id])
            if @plan.group
                if @plan.group.mailchimp_key and @plan.group.mailchimp_list
                  if @plan.group.mailchimp_key != "" and @plan.group.mailchimp_list != "" 
                    begin
                      h = Hominid::API.new(@plan.group.mailchimp_key)
                      h.list_subscribe(@plan.group.mailchimp_list, current_user.email, {'FNAME' => current_user.first_name, 'LNAME' => current_user.last_name}, 'html', false, true, true, false)
                    rescue
                    
                    end
                  end
                end
            end

         end

         @plan = Plan.find(params[:plan_id]) 

         for organizer in @plan.organizers
           if organizer.privacy_cc_signups
             Postoffice.notify_signup(current_user, @plan, organizer).deliver
           end
         end


        
   
        
       
       

         @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =?",params[:plan_id]])
         
    end
  
  
  
  
  
  
  
end
