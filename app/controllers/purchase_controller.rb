class PurchaseController < ApplicationController
  
  
  def index
  end

  def show
    
    if !current_user
      redirect_to "/escapes/#{params[:id]}"
    end
    
    
    @plan = Plan.find(params[:id])
    
    @tickets = @plan.tickets.sort_by_type
    
    
  end


  def create
    
   
    
  end








  def destroy
  end

end
