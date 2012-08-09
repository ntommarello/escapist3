class DislikesController < ApplicationController
  before_filter :login_from_token
  
  def create
      if !current_user
        ChallengeCookie_Write()
      else
        Dislike.create(:user_id => current_user.id, :challenge_id=>params[:challenge_id])
      end

      render :nothing => true
   end

   def destroy
     if !current_user
       ChallengeCookie_Delete()
     else
       if @like = Dislike.find_by_challenge_id_and_user_id(params[:challenge_id],current_user.id)
         @like.destroy
       end
     end

     render :nothing => true
   end



   def ChallengeCookie_Write
     if cookies[:dislikes]
       if cookies[:dislikes].blank?
         cookies[:dislikes] = params[:challenge_id]
       else
         cookies[:dislikes] = cookies[:dislikes] << ",#{params[:challenge_id]}"
       end
     else
       cookies[:dislikes] = params[:challenge_id]
     end
   end

   def ChallengeCookie_Read
     @challenges =  cookies[:dislikes].split(",") 
   end

   def ChallengeCookie_Delete
     @challenges =  cookies[:dislikes].split(",")
     @challenges_modify = "0"
     for var in @challenges
       if var != params[:challenge_id]
 		    @challenges_modify = "#{@challenges_modify},#{var}"
 		  end
 	  end
 	  cookies[:dislikes] = @challenges_modify
   end
   
   
end





