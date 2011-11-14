class TicketsController < ApplicationController
  
  def index
  end

  def show
    

    
    @subscribed = SubscribedPlan.find(params[:id])
    @plan = @subscribed.plan
    @user = @subscribed.user
    @purchased = TicketPurchase.find(:all, :conditions=>"subscribed_plan_id=#{@subscribed.id}", :include=>:ticket, :limit=>100)
    

    
    @showTickets = false;

    if @group and current_user
      @showTickets = @group.check_admin(current_user)
    end

    if current_user and current_user.mod_level == 5
      @showTickets = true
    end
    
    if current_user and current_user.id == @user.id
      @showTickets = true
    end
    
    unless @showTickets
      redirect_to "/"
    end
    
    
    render :layout=>false
  end

end
