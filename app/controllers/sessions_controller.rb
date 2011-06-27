class SessionsController < Devise::SessionsController
  include GeoKit::Geocoders


  def twitter_setup
    
    @fb
    
    
    request.env['omniauth.strategy'].consumer_key = current_user.consumer_key
    request.env['omniauth.strategy'].consumer_secret = current_user.consumer_secret

    render :text => "Setup complete.", :status => 404
  end
    
  def twitter_setup
    request.env['omniauth.strategy'].consumer_key = TWITTER_KEY
    request.env['omniauth.strategy'].consumer_secret = TWITTER_SECRET

    render :text => "Setup complete.", :status => 404
  end
    
    
    
  def new
    @user = User.new
    render(:template => 'devise/sessions/new')
  end

  def create   
    if !params[:mobile]
      resource = warden.authenticate!(:scope => resource_name, :recall => "failure")
      sign_in_and_redirect(resource_name, resource)
    else

      # TODO: clean this up... tests would be nice too :p
      if params[:auto_login_token]
        @user = User.find_by_authentication_token(params[:auto_login_token])
      else
        #@user = User.find_by_email(params[:email])
        params[:user] = {}
        params[:user][:email] = params[:email]
        params[:user][:password] = params[:password]
        @user = warden.authenticate!(:scope => :user)
      end

      if @user
        sign_in @user
        @user.phone_OS = params[:phone_OS] if params[:phone_OS]
        @user.phone_model = params[:phone_model] if params[:phone_model]
        @user.app_version = params[:app_version] if params[:app_version]
        @user.lat = params[:lat] if params[:lat]
        @user.lng = params[:lng] if params[:lng]
        @user.apply = params[:apply] if params[:apply]
        
        if params[:lat] and params[:lng]
          if params[:lat].to_i != 0
            loc=GoogleGeocoder.reverse_geocode([params[:lat] ,params[:lng] ])
            @user.location_city = "#{loc.city} #{loc.state}"

            if @user.hometown.nil?
              @user.hometown = "#{loc.city} #{loc.state}"
            end

          end
        end

        @user.save!
        @error = 0
      else
        user2 = User.find_by_email(params[:email])
        @error = user2 ? 2 : 1
      end

      respond_to do |format|
        format.xml { render }
        format.json { render :json => @user.to_json }
      end
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource = nil)
    scope      = Devise::Mapping.find_scope!(resource_or_scope)     
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource

    # if request.xhr?
      # render :json => { :success => true, :redirect  => stored_location_for(scope) || after_sign_in_path_for(resource) } 
    # else
      redirect_to(stored_location_for(scope) || after_sign_in_path_for(resource))
    # end
  end
            
  def failure
    flash[:alert] = "Invalid email or password."

    # if request.xhr?
    #   render :json => { :success => false, :errors => { :reason => "Login failed. Try again" }} 
    # else
      # redirect_to(new_user_session_path)
      redirect_to(request.env['HTTP_REFERER'] || new_user_session_path)
    # end
  end   
end
