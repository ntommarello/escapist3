class WebController < ApplicationController
 
  def new_home

     if params[:id]
       @start_plan = Plan.find(:all, :conditions=>["id=?", params[:id].to_i],:order=>"start_time asc")
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
     
     conditions = ""
     if @group
       @slogan = @group.subtitle
       conditions = "and plans.group_id = #{@group.id}"
     else
       @slogan = "Kickass adventures with awesome people"
       conditions = "and city_id = #{@city_id}"
     end
     

     t = Time.zone.now
     rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
     
     if @group  #todo: eventually allow private within a group
       @plan = Plan.published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? #{conditions}", rounded_t],:order=>"start_time asc")
     else
       @plan = Plan.public_published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? #{conditions}", rounded_t],:order=>"start_time asc")
     end
     
     
     #add in ones user is author for
     if current_user
       for plan in current_user.plans_authored
        if plan.published == false 
          @add_plan = Plan.find(:all, :conditions=>["id=?",plan.id])
          @plan = @plan + @add_plan
        end
       end
     end
     
     
     
     @start_id = 0;
     if @start_plan
       @ids = @plan.collect(&:id)
       @start_id = @ids.find_index(@start_plan[0].id.to_i)

       if !@start_id 
         @start_id = 0
         @plan = @start_plan + @plan
       end
     end

     @plan_json = @plan.to_json(:include=>[:users, :organizers], :only=>[:first_name, :last_name, :published, :id, :title, :note, :url_name, :short_desc, :short_location, :start_time, :price, :avatar_file_name, :username, :image_file_name, :application_required])

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
  
  
 
  
  

  
  def weeklyemail
    
    @plan = Plan.find(9)
    
    @challenge1 = Challenge.find(593)
    @challenge2 = Challenge.find(590)
    @challenge3 = Challenge.find(589)
    
    render :layout=>false
    
  end
  
 
  
  def apply
  
 end
 
 def upgrade_browser
   
   

 	
   render :layout=>false
   

 end
  

end
