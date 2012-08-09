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

  
    def update

      params[:ticket].each  do |key, value| 
          params[:ticket][key] = CGI::unescape(value)
          params[:ticket][key] = remove_end_breaks(params[:ticket][key])
      end
      
      if params[:ticket][:amount]
         params[:ticket][:amount] = params[:ticket][:amount].to_f * 100
      end


      @ticket = Ticket.find(params[:id])
      @ticket.update_attributes(params[:ticket])
      @ticket.save
      
       @plan = Plan.find(@ticket.plan_id)
       
      
      @all_tickets = @plan.tickets.filter_by_ticket
      
      num = 0
      max = 0
      min = 0
      
      for ticket in @all_tickets
        if num == 0
          min = ticket.amount
          max = ticket.amount
        end
        
        if ticket.amount < min
          min = ticket.amount
        end
        if ticket.amount > max
          max = ticket.amount
        end
        
        num = num + 1
      end
      
     
      @plan.price = (min.to_f / 100).to_f
      @plan.price_max = (max.to_f / 100).to_f
      @plan.save

      render :nothing => true




    end
  





end





