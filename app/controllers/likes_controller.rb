class LikesController < ApplicationController
  
  def create
    
    Like.create(:user_id => current_user.id, :subscribed_challenge_id=>params[:likes][:subscribed_challenge_id])
    
    @like = SubscribedChallenge.find(params[:likes][:subscribed_challenge_id])
    
    if @like.user.messaging_bucket_comment
      if @like.user.id != current_user.id
        
        @challenge_url = "#{@like.challenge.id}-#{@like.challenge.title.parameterize}"
        
        Postoffice.cc_like(current_user.first_name, current_user.last_name, current_user.id, 
                              @like.user.email,"", 
                              @like.user.authentication_token, @like.challenge.title,@challenge_url).deliver
      end
    end
    
 
    render :partial=>"likes/likes_display", :locals=>{:log=>@like} 
    
  end

  def destroy
    
    @like = Like.find_by_subscribed_challenge_id_and_user_id(params[:id],current_user.id)
    @c = SubscribedChallenge.find(@like.subscribed_challenge_id)
    
    if @like.user_id == current_user.id
 	    @like.destroy
 	  end

    render :partial=>"likes/likes_display", :locals=>{:log=>@c }
    
 	  
  end

end
