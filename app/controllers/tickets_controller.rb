class TicketsController < ApplicationController
  
  def index
  end

  def show
    

    
    @subscribed = SubscribedPlan.find(params[:id])
    @plan = @subscribed.plan
    @user = @subscribed.user
    @purchased = TicketPurchase.find(:all, :conditions=>"subscribed_plan_id=#{@subscribed.id}", :include=>:ticket)
    
    if !current_user
      redirect_to "/"
    end
    if current_user.mod_level < 5
      if current_user.id != @user.id
        redirect_to "/"
      end
    end
    
    render :layout=>false
  end

end
