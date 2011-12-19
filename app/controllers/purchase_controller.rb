class PurchaseController < ApplicationController
  
  
  def index
  end

  def show
    
    if !current_user
      redirect_to "/escapes/#{params[:id]}"
    end
    
    
    @plan = Plan.find(params[:id])
    plan_access_control
   
    
    
  end


  def create
    
   
    
  end








  def destroy
  end

end
