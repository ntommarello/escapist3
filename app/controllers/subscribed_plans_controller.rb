class SubscribedPlansController < ApplicationController
  before_filter :login_from_token
  
  def create
    
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
         SubscribedPlan.create(:plan_id => params[:plan_id], :user_id=>current_user.id, :maybe=>@maybe)
       end
        
       @plan = Plan.find(params[:plan_id]) 
       
       @challenge_url = "#{@plan.id}-#{@plan.title.parameterize}"
       Postoffice.cc_comment(current_user.first_name, current_user.last_name, current_user.id, 
                             @plan.organizers[0].email, "", 
                             @plan.organizers[0].authentication_token, @plan.title,@challenge_url,"joined").deliver
       
       
       
       @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =?",params[:plan_id]])
       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees, :hosts=>@plan.organizers}
       
     
       	
   end
   
   


   def destroy
       @splan = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
       @splan.destroy
       @plan = Plan.find(params[:plan_id])
       @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =? ",params[:plan_id]])
       
      render :partial=>"plans/signups", :locals=>{:attendees=>@attendees, :hosts=>@plan.organizers}
        
    end


end
