class SubscribedPlansController < ApplicationController
  
  
  
  
  before_filter :login_from_token
  
  def create
    
    sign_up_plan
       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}
   end
   
   
   def payment

     check = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
      #users can buy more tickets
      if check
        check.num_guests = check.num_guests + params[:qty].to_i 
        check.amount = check.amount + params[:amount].to_i
        check.save!
        @subscribed = check
        @plan = Plan.find(params[:plan_id])
        @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =?",params[:plan_id]])
        
      else
        sign_up_plan
        @subscribed.amount = params[:amount]
        @subscribed.num_guests = params[:qty].to_i - 1
         @subscribed.save!
      end

     token = params[:token]
     
     if Rails.env == "production"
       
       if @plan.group and @plan.group.stripe_private
         Stripe.api_key = @plan.group.stripe_private
       else
         Stripe.api_key = "v5iEXYC6gDJ849q648HgP20UJ5HbVOU5"
       end
       
       customer = Stripe::Customer.create(:card => token, :description => "#{current_user.id} | #{current_user.first_name} #{current_user.last_name} | #{current_user.email} | plan: #{@plan.id}" )
       Stripe::Charge.create(
           :amount => params[:amount].to_i, # in cents
           :currency => "usd",
          :customer => customer.id
       )
    end
      
     current_user.stripe_id = params[:token]
     current_user.save!
     
    


       if @plan.price and @plan.price > 0
         if current_user.discount_active == true
           current_user.discount_active = false
           current_user.save
         end 
       end

       Postoffice.deliver_confirmation(current_user,@plan)

       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}

   end





   def destroy
    
       @splan = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
       @splan.destroy
       @plan = Plan.find(params[:plan_id])

       if @plan.group
         if @plan.group.mailchimp_key
          h = Hominid::API.new(@plan.group.mailchimp_key)
          h.list_unsubscribe(@plan.group.mailchimp_list, current_user.email, true, false, false)
        end
       end

       @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =? ",params[:plan_id]])
       
       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}

    end


end
