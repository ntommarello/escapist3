class ApplicationController < ActionController::Base
  require 'koala'

  before_filter :locate_user
  before_filter :check_note
  before_filter :set_cache_headers

  def check_note
    @displayNote = false
    unless current_user
      
      @count_bucket = 0
    	if cookies[:challenges]
    	    @var =  cookies[:challenges].split(",")
      		for var in @var
    			  if var != "0"
      			  @count_bucket = @count_bucket + 1
            end
      		end
    	 end
    	 
    	@count_dislike = 0
     	if cookies[:dislikes]
     	    @var =  cookies[:dislikes].split(",")
       		for var in @var
     			  if var != "0"
       			  @count_dislike = @count_dislike + 1
             end
       		end
     	 end
     	 
     	 
     	 @count_stomped = 0
      	if cookies[:stomped]
      	    @var =  cookies[:stomped].split(",")
        		for var in @var
      			  if var != "0"
        			  @count_stomped = @count_stomped + 1
              end
        		end
      	 end
      	 
      	 
      	 @count_created = 0
        	if cookies[:challenges_created]
        	    @var =  cookies[:challenges_created].split(",")
          		for var in @var
        			  if var != "0"
          			  @count_created = @count_created + 1
                end
          		end
        	 end
      	 
    	 if @count_created == 0 and @count_stomped == 0 and 	@count_dislike == 0 and 	@count_bucket == 0
    	   @displayNote = false
    	 else
    	   @displayNote = true
    	 end
      
    end
  end


  def set_cache_headers
    #Brute force hack.  For ajax back button stuff. Otherwise stale content loaded.
    
    #response.headers['Cache-Control'] = 'no-store'
    #response.headers['Vary'] = '*'
    
    @browser = Browser.new(:ua => request.env["HTTP_USER_AGENT"], :accept_language => "en-us")
  end
  
  protected
  
  def login_from_token
    if params[:auto_login_token]
      user = User.find_by_authentication_token(params[:auto_login_token])
      sign_in(user) if user
    end 
  end

  def check_cookies
     if cookies[:challenges]
       add_challenges_from_cookie(cookies[:challenges])
       cookies.delete :challenges
     end

     if cookies[:challenges_created]
       add_challenges_from_cookie(cookies[:challenges_created], true)
       cookies.delete :challenges_created
     end
     
     if cookies[:dislikes]
        challenges = cookies[:dislikes].split(',')
        challenges.each do |challenge_id|
            check = Dislike.find_by_user_id_and_challenge_id(current_user.id,challenge_id)
            if !check
              if challenge_id != "0"
                Dislike.create(:user_id => current_user.id, :challenge_id=>challenge_id)
              end
            end
        end
        cookies.delete :dislikes
     end
     
     if cookies[:stomped]
        challenges = cookies[:stomped].split(',')
        challenges.each do |challenge_id|
            check = SubscribedChallenge.find_by_user_id_and_challenge_id(current_user.id,challenge_id)
            if !check
              if challenge_id != "0"
                SubscribedChallenge.create(:user_id => current_user.id, :challenge_id=>challenge_id, :date_completed_on=>Time.now, :completed=>true)
              end
            end
        end
        cookies.delete :stomped
     end
     
     
     
   end

   def add_challenges_from_cookie(challenges, authored = false)
     challenges = cookies[authored ? :challenges_created : :challenges].split(',')
     challenges.each do |challenge_id|
       if challenge_id != "0" && (challenge = Challenge.find(challenge_id))
         if authored
           challenge.update_attribute(:author_id, current_user.id)
         else
           check = SubscribedChallenge.find_by_user_id_and_challenge_id(current_user.id,challenge_id)
           if !check
             SubscribedChallenge.create(:challenge => challenge, :user_id => current_user.id, :completed => false)
           end
         end
       end
     end
  end
  
  

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) 
      check_cookies
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
  
	
  
  
end
