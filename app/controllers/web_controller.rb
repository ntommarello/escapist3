class WebController < ApplicationController
 
  def new_home

     if params[:id]
       @start_plan = Plan.find(:all, :conditions=>["id=?", params[:id].to_i],:order=>"start_time asc", :include=>:user)
       if @start_plan 
         @city_id = @start_plan[0].city_id
         #@no_ids = "(#{@start_plan[0].id})"  
         session[:dropdown_city_value] = @city_id
         if @city_id == 1
           session[:dropdown_city] = "Boston"
         end
         if @city_id == 2
           session[:dropdown_city] = "San Francisco"
         end
         if @city_id == 3
           session[:dropdown_city] = "New York City"
         end
         if @city_id == 99
           session[:dropdown_city] = "World Travel"
         end
       end
     end

     if !@city_id
       @city_id = session[:dropdown_city_value];
     end

     t = Time.zone.now
     rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
     @plan = Plan.find(:all, :conditions=>["plans.featured=1 and start_time >= ? and city_id = ?", rounded_t, @city_id],:order=>"start_time asc", :include=>:user)

     @start_id = 0;
     if @start_plan
       @ids = @plan.collect(&:id)
       @start_id = @ids.find_index(@start_plan[0].id.to_i)

       if !@start_id 
         @start_id = 0
         @plan = @start_plan + @plan
       end

     end

     @plan_json = @plan.to_json(:include=>[:user,:users], :only=>[:first_name, :id, :title, :note, :url_name, :start_time, :price, :avatar_file_name, :username, :image_file_name])

     if !@skip
       render 
     end
   end


   def new_refresh_container

     session[:dropdown_city_value] = params[:dropdown_city_value] || "Boston"
     session[:dropdown_city] = params[:dropdown_city] || "1"
     @skip = true
     new_home
     render :json => @plan_json, :layout=>false

   end
   

  def rewards
    
    if params[:mobile]
      @limit=25
    else
      @limit=100
    end
    
    #temp:  Will need to use subscribed_challenges to figure out when points were awarded
    @leaders = User.active.sort_photos_first.find(:all, :order=>"score desc", :limit=>@limit)
    respond_to do |format|
        format.xml { render }
         format.html { render }
        format.json { render :json => @leaders.to_json }
    end

  end


  def about
  end

  def jobs
  end

  def tos
    
    #this is iphone
    if params[:nolayout]
      render :layout=>false
    end
  end

  def privacy_policy
  end
  
  def settings
    
    if !current_user
      redirect_to root_path
      return
    end
    
    
    
    
    
    @user = current_user
    
    #bug with boolean values in select list
    if @user.privacy_allow_messages
      @privacy_allow_messages = 1
    else
      @privacy_allow_messages = 0
    end
      
  end
  
  
  def live_search
    
    @limit = 7
    set_search_vars
    
    render :layout => false
             
    
  end
  
  
  def search
      @limit = 1000
      set_search_vars
  end
  
  
  def set_search_vars
    @search_text = params[:search_text]
    lat = (session[:lat] / 180.0) * Math::PI 
    lng = (session[:lng] / 180.0) * Math::PI
    @conditions = {:published=>1}
     
    @results = Challenge.search "#{@search_text}*", :geo => [lat,lng], :order=>"@geodist ASC", :match_mode => :extended, :with=> @conditions, :limit=>@limit   
  
    #@results = ThinkingSphinx.search "#{@search_text}*",  :geo => [lat,lng], :order=>"@geodist ASC", :match_mode => :extended, :limit=>@limit   
  
  
  end  
  
  

  
  def weeklyemail
    
    @plan = Plan.find(9)
    
    @challenge1 = Challenge.find(593)
    @challenge2 = Challenge.find(590)
    @challenge3 = Challenge.find(589)
    
    render :layout=>false
    
  end
  
 
  
  def apply
  
 end
  

end
