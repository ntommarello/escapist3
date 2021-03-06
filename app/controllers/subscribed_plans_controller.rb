class SubscribedPlansController < ApplicationController
  
  
  
  
  before_filter :login_from_token
  
  def create
    
        sign_up_plan
        @ticket = TicketPurchase.create(:subscribed_plan_id => @subscribed.id, :plan_id => @plan.id, :payer_user_id=>current_user.id, :ticket_id=>0, :amount=>0)
        random = SecureRandom.hex(10)
        qr_code = "#{@ticket.id}-#{random}"
        @ticket.user_id = current_user.id
        @ticket.qr_code = qr_code
        @ticket.save
        
        #Postoffice.deliver_confirmation(current_user,@plan,@subscribed)
            
        Postoffice.send_later(:deliver_confirmation, current_user,@plan,@subscribed)

        render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}
       
   end
   
   

   
   
   
    #purchase[plan_id], #purchase[grand_total],  purchase[discount_code], purchase[discount]



     #array of purchases:  ticket_id, qty, amount after discount
        #suscribed_id, plan_id, current_user
        
        
   def payment

     check = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
      #users can buy more tickets
      if check
        if !check.num_guests
          check.num_guests = 0
        end
        if !check.amount
          check.amount = 0
        end
        check.num_guests = check.num_guests + params[:qty].to_i 
        check.amount = check.amount + params[:amount].to_i
        check.discount_code = params[:discount_code]
        check.extra_info = "#{check.extra_info} \n #{params[:extra_info]}"
        check.discount = check.discount.to_i + params[:discount].to_i
        check.donation = check.donation.to_i + params[:donation].to_i
        check.save!
        @subscribed = check
        @plan = Plan.find(params[:plan_id])
        @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =?",params[:plan_id]])
        
      else
        sign_up_plan
        @subscribed.amount = params[:amount]
        @subscribed.num_guests = params[:qty].to_i - 1
        @subscribed.extra_info = params[:extra_info]
        @subscribed.discount = params[:discount]
        @subscribed.donation = params[:donation]
        @subscribed.discount_code = params[:discount_code]
        @subscribed.save!
      end
      
 
    if params[:tickets]
       parsed_json = ActiveSupport::JSON.decode(params[:tickets])
      ticketHolders = ActiveSupport::JSON.decode(params[:ticketHolders])
      
      
       num = 0
        for ticket in parsed_json["tickets"]
          #check = TicketPurchase.find(:first, :conditions=>"subscribed_plan_id = #{@subscribed.id} and plan_id=#{@plan.id} and user_id=#{current_user.id} and ticket_id=#{ticket['id']}")
          #if check
          #  check.qty = check.qty + ticket["qty"].to_i
          #  check.amount = check.amount + ticket["amount"].to_i
          #  check.save!
          #else
            
            (1..ticket["qty"].to_i).each do |i|
              
              @ticket = TicketPurchase.create(:subscribed_plan_id => @subscribed.id, :plan_id => @plan.id, :payer_user_id=>current_user.id, :ticket_id=>ticket["id"], :amount=>ticket["amount"])
              random = SecureRandom.hex(10)
              qr_code = "#{@ticket.id}-#{random}"
              @ticket.qr_code = qr_code
              
              @ticket.user_email = ticketHolders[num]["user_email"]
              @ticket.user_name =  ticketHolders[num]["user_name"]
              
              if @ticket.user_email == current_user.email
                @ticket.user_id = current_user.id
              end
              
              if ticketHolders.length == 1 and ticketHolders[0]["user_email"] == ""
                @ticket.user_id = current_user.id
              end
                          
              
              @ticket.save
              
              num = num + 1
              
            end  
        end
     end

     token = params[:token]
     
     if Rails.env == "production"
       
       if @plan.group and @plan.group.stripe_private
         Stripe.api_key = @plan.group.stripe_private
       else
         Stripe.api_key = "v5iEXYC6gDJ849q648HgP20UJ5HbVOU5"
       end
       
       customer = Stripe::Customer.create(:card => token, :description => "#{current_user.id} | #{current_user.first_name} #{current_user.last_name} | #{current_user.email} | plan: #{@plan.id}" )
       
       charge = Stripe::Charge.create(
           :amount => params[:amount].to_i, # in cents2
           :currency => "usd",
          :customer => customer.id
       )
       
       current_user.stripe_id = customer.id
       current_user.active_card = "#{charge.card.type} ending in #{charge.card.last4} (#{charge.card.exp_month}/#{charge.card.exp_year})"
       current_user.save!
       
       @subscribed.charge_id = charge.id
       @subscribed.save!
       
    end
      
       if @plan.price and @plan.price > 0
         if current_user.discount_active == true
           current_user.discount_active = false
           current_user.save
         end 
       end

       #Postoffice.deliver_confirmation(current_user,@plan,@subscribed)
       Postoffice.send_later(:deliver_confirmation, current_user,@plan,@subscribed)


       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}

   end





   def destroy
    
       @splan = SubscribedPlan.find_by_plan_id_and_user_id(params[:plan_id],current_user.id)
       @splan.destroy
       @plan = Plan.find(params[:plan_id])

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

       @attendees = User.sort_photos_first.find(:all, :joins=>:subscribed_plans, :conditions=>["subscribed_plans.plan_id =? ",params[:plan_id]])
       
       render :partial=>"plans/signups", :locals=>{:attendees=>@attendees}

    end
    
    
    
    def get_subscribed
      @subscribed = SubscribedPlan.find(:first, :conditions=>["plan_id= ? and user_id=?",params[:plan_id], current_user.id])
      @id = @subscribed.id
      
      render :layout=>false
    end


end
