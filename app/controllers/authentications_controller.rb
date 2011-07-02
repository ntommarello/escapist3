class AuthenticationsController < ApplicationController
   require 'open-uri'
   
   
   
 
   
   
  def index
  end

  def create
  
    
    omniauth = request.env["omniauth.auth"]
     @secret = ""
     if omniauth['credentials']['secret']
       @secret = omniauth['credentials']['secret']
    end
    
    
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    #if already have auth link and account
    if authentication
      authentication.token = omniauth['credentials']['token']
      authentication.secret = @secret
      authentication.save
      if authentication.user
        sign_in authentication.user
      else
        authentication.destroy
        redirect_to '/'
        return
      end
      if cookies[:redirect_settings]
           if omniauth['provider'] == "facebook"
             current_user.fb_extended_permissions = true
             current_user.save
           end
           cookies.delete :redirect_settings
           redirect_to settings_path
      else
        redirect_to request.env['omniauth.origin'] || '/'
        #redirect_to user_path(current_user)
      end
    elsif current_user
      #no need to add account, but add auth link
      if omniauth['provider'] == "facebook"
         parse_facebook_data(omniauth)
         if @user_params['birthday'] 
           current_user.birthday = @user_params['birthday']
         end
         if @user_params['gender']
           current_user.gender = @user_params['gender']
         end
         if @user_params['facebook_link']
            current_user.facebook_link  = @user_params['facebook_link']
         end
         current_user.save
       end
       if omniauth['provider'] == "twitter"
         current_user.twitter_link = omniauth['user_info']['nickname']
         current_user.save
       end
       

       
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token=>omniauth['credentials']['token'], :secret=>@secret)
      
      if cookies[:redirect_settings]
           cookies.delete :redirect_settings
           if omniauth['provider'] == "facebook"
             current_user.fb_extended_permissions = true
             current_user.save
           end
           redirect_to settings_path
      else
        redirect_to user_path(current_user)
      end
    else
      if omniauth['provider'] == "facebook"
         parse_facebook_data(omniauth)
       end
       if omniauth['provider'] == "twitter"
          parse_twitter_data(omniauth)
       end
       
       
      #user not logged in. check if account already exists. If so, add link
      check_existing = User.find_by_email(@user_params['email'])
      if check_existing
        sign_in check_existing
        if @user_params['birthday'] 
          current_user.birthday = @user_params['birthday']
        end
        if @user_params['gender']
          current_user.gender = @user_params['gender']
        end
        if @user_params['facebook_link']
           current_user.facebook_link  = @user_params['facebook_link']
        end
        
        if @avatar_link
          unless current_user.avatar_file_name
            begin
              tempfile = Tempfile.new("test")
              tempfile.write open(@avatar_link).read.force_encoding('utf-8')
              current_user.avatar  = tempfile
            rescue
            
            end  
          end
        end
        
        
        current_user.save
        current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token=>omniauth['credentials']['token'], :secret=>@secret)
        redirect_to user_path(current_user)
        
      else
        
        #totally new user: register
 
        
        user = User.new(@user_params)
        user.source = @source
        if @user_params['location_city']
          location = Geokit::Geocoders::MultiGeocoder.geocode(@user_params['location_city'])
          if location.lat
            user.lat = location.lat
            user.lng = location.lng
          end
        end
        
        
        if @avatar_link
          begin
            tempfile = Tempfile.new("test")
            tempfile.write open(@avatar_link).read.force_encoding('utf-8')
            user.avatar  = tempfile
          rescue
            
          end  
          
        end
        

        if user.save
          check_cookies
          sign_in user
          current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token=>omniauth['credentials']['token'], :secret=>@secret)
          
          location = request.env['omniauth.origin']  || root_path

          if location.include? "plans/"
            redirect_to location
          else
            redirect_to "/#{current_user.username}"
          end
          
          #redirect_to user_path(current_user)
          #redirect_to :back
          #request.env['omniauth.origin'] || '/'
        else
          session[:omniauth] = omniauth.except('extra')
          flash[:error] = user.errors.to_a.map { |msg| msg }.join(". ")
          redirect_to '/register'
        end
      end
    end
  end
  
  
  

  def destroy
    
    if params[:provider] == "twitter"
      current_user.twitter_link = nil
    end
    if params[:provider] == "facebook"
      current_user.facebook_link = nil
    end
    
    current_user.save
    
    authentication = Authentication.find_by_provider_and_user_id(params[:provider], current_user.id)
    authentication.destroy
    
    redirect_to settings_path
    
  end
  
  
  
  def parse_facebook_data(omniauth)
    @user_params = Hash.new
    @user_params['email'] = omniauth['extra']['user_hash']['email']
    @user_params['first_name'] = omniauth['user_info']['first_name']
    @user_params['last_name'] = omniauth['user_info']['last_name']
    @user_params['password'] = generate_password
    @user_params['temp_password'] = @user_params['password'] 
    if omniauth['extra']['user_hash']['hometown']
      @user_params['hometown'] = omniauth['extra']['user_hash']['hometown']['name']
    end
    if omniauth['extra']['user_hash']['location']
      @user_params['location_city'] = omniauth['extra']['user_hash']['location']['name']
    end
    if omniauth['extra']['user_hash']['birthday']
      @user_params['birthday'] = omniauth['extra']['user_hash']['birthday']
    end
    if omniauth['extra']['user_hash']['gender'] 
      if omniauth['extra']['user_hash']['gender'] == "male"
        @user_params['gender'] = 1
      else
        @user_params['gender'] = 2
      end
    end
    @user_params['facebook_link'] = omniauth['user_info']['urls']['Facebook']
    if omniauth['user_info']['urls']['Website']
      @user_params['website_link'] = omniauth['user_info']['urls']['Website']
    end
    
    if omniauth['user_info']['nickname']
      @custom_link = omniauth['user_info']['nickname']   #evntually use if firstname-lastname taken
    end
    
    @avatar_link = "http://graph.facebook.com/#{omniauth['extra']['user_hash']['id']}/picture?type=large"
    
    
  end
  
  
  
  
  
  
  
  
  def parse_twitter_data(omniauth)
    @user_params = Hash.new
    @user_params['email'] = omniauth['user_info']['email']
    
    names = omniauth['user_info']['name'].split
    lastname = names.pop
    firstname_remaining = names.join(' ')
    
    @user_params['first_name'] = firstname_remaining
    @user_params['last_name'] = lastname
    @user_params['password'] = generate_password
    @user_params['temp_password'] = @user_params['password'] 
    
    if omniauth['user_info']['location']
      @user_params['location_city'] = omniauth['user_info']['location']
    end
    
    @user_params['twitter_link'] = omniauth['user_info']['nickname']
    
    if omniauth['user_info']['urls']['Website']
      @user_params['website_link'] = omniauth['user_info']['urls']['Website']
    end
    
    if omniauth['user_info']['nickname']
      @custom_link = omniauth['user_info']['nickname']   #evntually use if firstname-lastname taken
    end
    
    if omniauth['user_info']['image']
      @avatar_link =  omniauth['user_info']['image'].gsub("_normal", "_bigger")
      @user_params['small_twitter_pic'] = true
    end
  
  end
  

end
