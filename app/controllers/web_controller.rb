class WebController < ApplicationController
 
 
  def spotlight
    
     challenge_list = "(2,34,37,43)" #default boston
     order = "(CASE WHEN id = 2 THEN 0 WHEN id = 34 THEN 1 WHEN id = 37 THEN 2 WHEN id = 43 THEN 3 END)"
     
     
     
     
     
   
     
     
     
     if session[:dropdown_city_value] == "1"  #boston
       @origin = [42.358431,-71.059773]
       challenge_list = "(2,34,37,43)"
       order = "(CASE WHEN id = 2 THEN 0 WHEN id = 34 THEN 1 WHEN id = 37 THEN 2 WHEN id = 43 THEN 3 END)"
     end
     if session[:dropdown_city_value] == "2"  #SF
       @origin = [37.77493,-122.419416] 
       challenge_list = "(66,311,67,68)"
       order = "(CASE WHEN id = 66 THEN 0 WHEN id = 311 THEN 1 WHEN id = 67 THEN 2 WHEN id = 68 THEN 3 END)"
     end
     if session[:dropdown_city_value] == "3"  #NYC
       @origin = [40.7144,-74.006]
       challenge_list = "(64,65,63,61)"
       order = "(CASE WHEN id = 64 THEN 0 WHEN id = 65 THEN 1 WHEN id = 63 THEN 2 WHEN id = 61 THEN 3 END)"
     end
     if session[:dropdown_city_value] == "99"  #globe
       @plan = Plan.find(4)
       challenge_list = "(59,17,21,58)"
       order = "(CASE WHEN id = 59 THEN 0 WHEN id = 17 THEN 1 WHEN id = 21 THEN 2 WHEN id = 58 THEN 3 END)"
       @challenge_count = Challenge.published.length
     else
       
       t = Time.zone.now
       rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
       
       @plan = Plan.find(:first, :conditions=>["plans.featured=1 and start_time >= ?", rounded_t],:origin => @origin, :within=>100,:order=>"start_time asc")
       
       
       
       @challenge_count = Challenge.published.find(:all, :conditions=>["city = ?",session[:dropdown_city_value].to_i]).length
     end
     
     if !@plan
       @plan = Plan.find(4)
      end
     
     @challenges = Challenge.find(:all, :conditions=>"published=1 and id in #{challenge_list}", :include=>[:user,:achievement], :origin => [session[:lat],session[:lng]], :order=>order)

     adrenaline_list = "(30, 58, 55, 50, 74, 67)"
     @ach = Achievement.find(:all, :conditions=>"id in #{adrenaline_list}")
     
     @leaders = User.active.sort_photos_first.find(:all, :order=>"score desc", :limit=>10)

     @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =?",@plan.id])
    
     conditionString = ""
     if session[:dropdown_city_value].to_i != 99   #99 indicates globe or not selected
       conditionString = "and city=#{session[:dropdown_city_value]}"
     end
     
     @page = 1
     if cookies[:spot_page]
       @page = cookies[:spot_page].to_i
     end 
     

     if @page < 2
       @challenge_hidden = Challenge.find(:first, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC")
     else
       @challenge = Challenge.find(:first, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC", :offset=>@page-1)
       @challenge_hidden = Challenge.find(:first, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC", :offset=>@page)
       if @challenge_hidden.nil?
         cookies[:spot_page] = "1"
         @page = 1
         @challenge_hidden = Challenge.find(:first, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC")
        end
    
     end
     
     if @page > 1
       @challenge_back = Challenge.find(:first, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC", :offset=>@page-2)
     end
     
     
     if current_user
 	      #@bucket_ids = SubscribedChallenge.all(:select => "challenge_id", 
 	       #       :conditions => "user_id = #{current_user.id} and completed !=1").collect(&:challenge_id)

 	      #@done_ids = SubscribedChallenge.all(:select => "challenge_id", 
 	      #                :conditions => "user_id = #{current_user.id} and completed = 1").collect(&:challenge_id)


 	    else
 	      #if cookies[:challenges]
 	      #  @bucket_ids = cookies[:challenges].split(',').map(&:to_i)
 	      #end
 	      #if cookies[:stomped]
 	      #  @done_ids = cookies[:stomped].split(',').map(&:to_i)
 	      #end
 		end
 		
    
    
  end
  
  
  def next_challenge
    conditionString = ""
    if session[:dropdown_city_value].to_i != 99   #99 indicates globe or not selected
      conditionString = "and city=#{session[:dropdown_city_value]}"
    end
    
    @page = params[:page].to_i - 1
    
   @challenge = Challenge.find(:first, :offset=>params[:page].to_i, :conditions=>"published=1 #{conditionString}", :order=>"challenges.editor_pick DESC, sum_todo_list DESC, subscribed_challenges_count DESC")
   @load = 1
    if current_user
	      @bucket_ids = SubscribedChallenge.all(:select => "challenge_id", 
	              :conditions => "user_id = #{current_user.id} and completed !=1").collect(&:challenge_id)

	      @done_ids = SubscribedChallenge.all(:select => "challenge_id", 
	                      :conditions => "user_id = #{current_user.id} and completed = 1").collect(&:challenge_id)


	    else
	      if cookies[:challenges]
	        @bucket_ids = cookies[:challenges].split(',').map(&:to_i)
	      end
	      if cookies[:stomped]
	        @done_ids = cookies[:stomped].split(',').map(&:to_i)
	      end
		end
   render :partial=>"web/spotlight_challenge", :locals=>{:challenge=>@challenge}
  
  
  end
  
  def refresh_spotlight
    
    session[:dropdown_city_value] = params[:dropdown_city_value] || "Boston"
    session[:dropdown_city] = params[:dropdown_city] || "1"
    spotlight
    render :partial => "web/featured"

  end
  
  def refresh_container
    
    session[:dropdown_city_value] = params[:dropdown_city_value] || "Boston"
    session[:dropdown_city] = params[:dropdown_city] || "1"
    spotlight
    @rerender = "1"
    render :partial => "web/refresh_container"

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
  
  

  def spotlight2
    
   end

  
  def weeklyemail
    
    @plan = Plan.find(9)
    
    @challenge1 = Challenge.find(593)
    @challenge2 = Challenge.find(590)
    @challenge3 = Challenge.find(589)
    
    render :layout=>false
    
  end
  
  def new_home
    
    
    #@no_ids = "(0)"
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
    

    
    #if @start_plan
    #  @plan = @start_plan + @plan
    #end
    
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
  
  def apply
  
 end
  

end
