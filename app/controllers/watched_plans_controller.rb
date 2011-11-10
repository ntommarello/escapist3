class WatchedPlansController < ApplicationController
  
  
  def create
    
    @plan = Plan.find(params[:plan_id])
    if @plan.group_id
      check = WatchedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
      if !check
        WatchedPlan.create(:plan_id => params[:plan_id], :user_id=>current_user.id, :group_id=>@plan.group_id)
      end
      
      if @plan.group.mailchimp_key and @plan.group.mailchimp_list
        h = Hominid::API.new(@plan.group.mailchimp_key)
        
        h.list_subscribe(@plan.group.mailchimp_list, current_user.email, {'FNAME' => current_user.first_name, 'LNAME' => current_user.last_name}, 'html', false, true, true, false)
      end
      
    else
      check = WatchedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
      if !check
        WatchedPlan.create(:plan_id => params[:plan_id], :user_id=>current_user.id)
      end
    end
  end


  def destroy
    @plan = Plan.find(params[:plan_id])
    if @plan.group_id
      @splan = WatchedPlan.find_by_group_id_and_user_id(@plan.group_id,current_user.id)
      @splan.destroy
      
      if @plan.group
        
        if @plan.group.mailchimp_key and @plan.group.mailchimp_list
          if @plan.group.mailchimp_key != "" and @plan.group.mailchimp_list != "" 
            begin
              
        
              h = Hominid::API.new(@plan.group.mailchimp_key)
        
              h.list_unsubscribe(@plan.group.mailchimp_list, current_user.email, true, false, false)
            rescue
              
            end
          end
        end
      end
      
      
    else
      @splan = WatchedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
      @splan.destroy
    end
  end

end