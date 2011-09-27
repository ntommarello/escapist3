class UsersController < ApplicationController
  include GeoKit::Geocoders

  before_filter :login_from_token, :only => [:profile, :show, :update]

  def profile
    if @user = current_user
      show
      render(:action => :show)
    else
      flash[:error] = "You must be logged in to view or edit your profile."
      redirect_to(root_url)
    end
  end
   
  def show
    @user ||= User.find_by_username(params[:username] || params[:id])
    @user ||= User.find_by_id(params[:id])
    
    unless @user
      redirect_to root_path
      return
    end
    
    # TODO: this should be refactored to a helper method or basic RBAC system
    @editable = current_user && (@user.id == current_user.id)

   
  end
  
  def register
    @user = User.new
  end
  
  def create
    
    @check = User.find_by_email(params[:user][:email]) 
    if @check
      flash[:error] = "#{params[:user][:email]} already has an account"
      redirect_to "/register"
      return
    end
    
    @user = User.new(params[:user])
    
    if params[:name]
      params[:name] =  params[:name].strip
      names = params[:name].split
      if names.length > 1
         @user.last_name = names.pop
         @user.first_name = names.join(' ')
      end
    end
    
    @user.location_city = session[:location_city]
    @user.hometown = session[:location_city]
    @user.lat = session[:lat] #TODO:  iphone and android will pass in lat/lng in params
    @user.lng = session[:lng]
    @user.source = @source
    
    if @user.save
      sign_in @user
      check_cookies      
      location = request.env["HTTP_REFERER"] || root_path





      if location.include? "escapes/"
        redirect_to :back
      else
        redirect_to "/#{@user.username}"
      end
      
  
    else
      flash[:error] = @user.errors.to_a.map { |msg| msg }.join(". ")
      render(:action => 'register')
    end
  end
  
  
  def update
    error = ""
    
    params[:user].each  do |key, value| 
       unless key == "avatar"
        params[:user][key] = CGI::unescape(value) 
        #params[:user][key] = remove_end_breaks(params[:user][key])
       end
     end
     
     
    current_user.update_attributes(params[:user])
      
    if params[:name]
      params[:name] =  params[:name].strip
      names = params[:name].split
      if names.length > 1
        current_user.last_name = names.pop
        current_user.first_name = names.join(' ')
      end
    end  
    
    if params[:verify_password]
      if params[:verify_password] == params[:new_password]
        #if params[:current_password] == current_user.password
          current_user.password = params[:new_password]
          current_user.temp_password = nil
        
        #end
      else
       # error = "Passwords don't match"
      end
      
    end
      
    if params[:email]
      check = User.find(:first, :conditions=>["id != ? and email= ? ",current_user.id,params[:email]])
      if check.nil?
        current_user.email = params[:email]
      else
        error = "Someone has that email"
      end
    end  
    
    if params[:username]
      check = User.find(:first, :conditions=>["id != ? and username= ? ",current_user.id,params[:username].downcase])
      if check.nil?
        current_user.username = params[:username].downcase
      else
        error = "Someone has that username"
      end
    end
    
      
      
    if params[:user][:location_city]
      location = params[:user][:location_city].gsub(%r{</?[^>]+?>}, '')
      location = location.gsub(/%3Cbr%3E/,'')
      location = location.gsub(/%20/,' ')

      loc = MultiGeocoder.geocode(location)
      if loc.success
        current_user.location_city = "#{loc.city} #{loc.state}"
        current_user.lat = loc.lat
        current_user.lng = loc.lng
      end
    end

    current_user.save!

    if params[:user][:privacy_cc_email]
      if error != ""
        flash[:message] = error
      else
        flash[:message] = "Settings updated"
      end
      redirect_to settings_path
    else
      if params[:user][:apply]
      redirect_to :back
      else
        redirect_to user_path(current_user)
      end
    end
  end
   
  def confirm_email
    if @user = User.find_by_authentication_token(params[:authentication_token])
      @user.confirmed_at = Time.now
      @user.save!
      sign_in @user       
    end
  end
  
  def destroy
    deleted_user = DeletedUser.new
    deleted_user.first_name = current_user.first_name
    deleted_user.last_name = current_user.last_name
    deleted_user.email = current_user.email
    deleted_user.login_count = current_user.sign_in_count
    deleted_user.account_creation = current_user.created_at
    deleted_user.why = params[:why]
    deleted_user.save!
    current_user.destroy
    redirect_to '/'
  end
  
  
  def my_challenges
 
     @my_challenges = ""
    if current_user and current_user.mod_level = 5
      @admin = true
    else
      @admin = false
    end
    
    if current_user
      @my_challenges = Challenge.find(:all, :select=>"challenges.*, (select count(*) from subscribed_challenges where completed=1 and challenge_id=challenges.id) as stomped, (select count(*) from subscribed_challenges where completed!=1 and challenge_id=challenges.id) as bucketed", :conditions=>["author_id=?",current_user.id], :order=>"created_at DESC")
    else
      if cookies[:challenges_created]
        @var =  cookies[:challenges_created].split(",")
        @tokens="0"
  		  for var in @var
  			  @tokens = "#{@tokens},#{var}"
  		  end

        @my_challenges = Challenge.paginate(:all,  :page => params[:page], :select=>"challenges.*, 0 as bucketed, 0 as stomped", :conditions=>"challenges.id in (#{@tokens})")
      end
    end
    
    if params[:sort]
      if params[:sort] == "stomped"
        @my_challenges = @my_challenges.sort_by { |u| -u.stomped.to_i}
      end
      if params[:sort] == "bucketed"
        @my_challenges = @my_challenges.sort_by { |u| -u.bucketed.to_i}
      end
    end
  end

  def mobile_create
      session[:lat] = params[:lat] unless params[:lat].blank?
      session[:lng] = params[:lng] unless params[:lng].blank?

      @error = 0  
      @user = User.find_by_email(params[:email])
      
      if @user
        @error = 1  #email account exists
        @message = "A user with that email address already exists."
      else 
        @source = params[:source]
        @user = User.new
        @user.email = params[:email]
        @user.password = params[:password]
        @user.first_name= params[:first_name]
        @user.last_name= params[:last_name]
        @user.lat = session[:lat]
        @user.lng = session[:lng]
        @user.source = params[:source]
        @user.phone_model = params[:phone_model]
        @user.phone_OS = params[:phone_OS]
        @user.app_version = params[:app_version]

        if session[:lat] and session[:lng]
          if session[:lat].to_i != 0
            loc = GoogleGeocoder.reverse_geocode([session[:lat] ,session[:lng] ])
            @user.location_city = "#{loc.city} #{loc.state}"

            if @user.hometown.nil?
              @user.hometown = "#{loc.city} #{loc.state}"
            end 
          end 
        end 

        @user.save!
        if @user.save
            sign_in @user
        end
      end

    respond_to do |format|
      format.xml { render }
      if @error == 1
        format.json { render :status => 400, :text => @message }
      else
        format.json { render :json => @user.to_json }
      end
    end
  end
   
   
   def scan_addressbook

    @names = JSON.parse(params[:emails_json])



     @follow = Array.new
     @invite = Array.new

     for name in @names

       #TODO: Seperate when we have follower feature
       #@checkuser = User.find_by_email(name['email'].downcase)
       #if @checkuser
      #   @checkfollow = Follow.find(:first, :conditions=>"follower_id=#{@user.id} and followed_id=#{@checkuser.id}")
      #   if @checkfollow.nil?
       #    @follow << @checkuser
      #   end
      # else
       #  @checkinvite = Invites.find(:first, :conditions=>"user_id=#{@user.id} and email='#{name['email'].downcase}'")
      #    if @checkinvite.nil?
            @invite << name
       #   end
      # end


     end


     respond_to do |wants|
       wants.xml { render  }
     end
   end


   def invite
    

     if params[:auto_login_token]
        @user = User.find_by_authentication_token(params[:auto_login_token])
     end
     
     Invite.create(:user_id=>@user.id, :email=>params[:email])
     Postoffice.deliver_invite(params[:email], @user.first_name, @user.last_name, params[:name], @user.username)

   end
end
