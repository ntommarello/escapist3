class SubscribedPlansController < ApplicationController
  
  
  
  
  before_filter :login_from_token
  
  def create
    
    sign_up_plan
       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}
   end
   
   
   def payment


     sign_up_plan


     #token = params[:stripeToken]
     #Stripe.api_key = "AwkVJfIN1Ju9ruvzZTM5A1xiTuSDdMxW"
     #customer = Stripe::Customer.create(:card => token, :description => "payinguser@example.com" )
     #Stripe::Charge.create(
    #     :amount => params[:amount].to_i, # in cents
    #     :currency => "usd",
     #    :customer => customer.id
     #)
     #save_stripe_customer_id(current_user, customer.id)





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
