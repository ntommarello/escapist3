class BlocksController < ApplicationController
  def create
    @flagged = false
    if params[:flag] == "1"
      @flagged = true
    end
    pointcalc
    
    Block.create(:user_id => @current_user.id, :receiver_id=>params[:receiver_id], :flag=>@flagged, :flag_reason=>params[:flag_reason])
    
    @blockedUser = User.find(params[:receiver_id])
    if current_user.mod_level == 5 
      if @flagged == false
        @blockedUser.hidden_reputation = 0
      end
    else
        @blockedUser.hidden_reputation = @blockedUser.hidden_reputation -  @pointloss
    end
    @blockedUser.save
    
    #TODO:  Break any future subscriptions/following feature on block
    	
    Message.update_all("deleted_receiver = 1", "user_id=#{params[:receiver_id]} and receiver_id=#{current_user.id}")
    
    #warns are not done via ajax request
    if @flagged
      redirect_to request.env['HTTP_REFERER']
    end
  end

  def destroy
    @thread = Block.find(:first, :conditions=>["user_id=? and receiver_id=?",current_user.id,params[:receiver_id]])
	  @flagged = @thread.flag
    pointcalc
	  
	  @thread.destroy
	  
	  @blockedUser = User.find(params[:receiver_id])
	  
	  if current_user.mod_level == 5
      @blockedUser.hidden_reputation = 100
    else
      @blockedUser.hidden_reputation = @blockedUser.hidden_reputation + @pointloss
      if @blockedUser.hidden_reputation > 100
        @blockedUser.hidden_reputation = 100
      end
    end
    @blockedUser.save!
	end
	
	def pointcalc
	  if @flagged 
      @pointloss = 10
    else
      @pointloss = 2
    end
  end
end
