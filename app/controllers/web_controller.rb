class WebController < ApplicationController
 
  def new_home

     if params[:id]
       @start_plan = Plan.find(:all, :conditions=>["id=?", params[:id].to_i],:order=>"start_time asc")
       if @start_plan.length > 1
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
           session[:dropdown_city] = "World"
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
       if @group.id == 21 and @city_id.to_i != 99
         conditions = "#{conditions} and city_id = #{@city_id}"
       end
     else
       @slogan = "Kickass adventures with awesome people"
       conditions = "and city_id = #{@city_id}"
     end
     

     t = Time.zone.now
     rounded_t = Time.local(t.year, t.month, t.day, 0, 0)
     
     if @group  #todo: eventually allow private within a group
       
       
       if @group.id == 9  #temp hack for snowriders
         conditions = "#{conditions} or id in #{@snowriders}"
        end
        
        

        
        
       
       @plan = Plan.published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? #{conditions}", rounded_t],:order=>"start_time asc")
     else
       @plan = Plan.public_published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? #{conditions}", rounded_t],:order=>"start_time asc")
     end
     
     
     
     #add in past event if no events
     if @group
       if @plan.length == 0
           @plan = Plan.published.find(:all, :conditions=>["plans.featured=1  #{conditions}"],:order=>"start_time desc")
        end
     end
     
     #add in world travel ones at end.  Should be refactored into one query.
     if !@group
       if @city_id.to_i != 99
         @world_plans =  Plan.public_published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? and city_id=99", rounded_t],:order=>"start_time asc")
         @plan = @plan + @world_plans
       else
         @other_plans =  Plan.public_published.find(:all, :conditions=>["plans.featured=1 and start_time >= ? and city_id!=99", rounded_t],:order=>"start_time asc")
         @plan = @plan + @other_plans
       end
     end
     
     #add in ones user is author for
     if current_user
       
       if @group
         my_plans = current_user.plans_authored.filter_group(@group.id)
       else
         my_plans = current_user.plans_authored
       end
       
       for plan in my_plans
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

     for plan in @plan
        plan.image_file_size = plan.signups
       
     end


     @plan_json = @plan.to_json(:include=>[:users, :organizers, :subscribed_plans], :only=>[:first_name, :image_file_size, :last_name, :published, :id, :title, :note, :url_name, :short_desc, :short_location, :start_time, :price, :avatar_file_name, :username, :image_file_name, :privacy, :enable_signups, :application_required])




   	#short term hack to determine if password should show. Only works with one event on @group	
   	@bypass_password = 0;
   	
   	
   	 if @plan[0]
   	    if @plan[0].privacy == 3
   	      @bypass_password = 1;
   	   
     	    if current_user
            for host in @plan[0].hosts
             if host.user_id == current_user.id
                @bypass_password = 0;
              end
            end
            if current_user.mod_level == 5
              @bypass_password = 0;
            end
          end
   	
   	      if cookies[:password]
            if cookies[:password].downcase == @plan[0].password.downcase
              @bypass_password = 0;
            end
          end
       end
    end



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
  
 
  
  def test
    
    @plans = SubscribedPlan.find(:all, :conditions=>"plan_id=46")
    
    for plan in @plans
      max = plan.num_guests.to_i + 1
      num = 0
      (1..max).each do |i|
        num = num +1
        @ticket = TicketPurchase.create(:subscribed_plan_id => plan.id, :plan_id => plan.plan_id, :payer_user_id=>plan.user_id, :ticket_id=>5, :amount=>1000, :qty=>1)
        random = SecureRandom.hex(10)
        if num==1
          @ticket.user_id=plan.user_id
        end
        qr_code = "#{@ticket.id}-#{random}"
        @ticket.qr_code = qr_code
        @ticket.save
      end
    end

    
    render :layout=>false
  
 end
 
 
 def upgrade_browser
   
   

 	
   render :layout=>false
   

 end
 
 
 def host_an_adventure
   
  if current_user and current_user.mod_level > 1 and current_user.plans_authored.length > 0
    redirect_to "/my_escapes"   
  end
   
 end
  

end
