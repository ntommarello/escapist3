class CommentsController < ApplicationController
  
  
  
  def create
    
    Comment.create(:user_id => current_user.id, :plan_id=>params[:comments][:plan_id], :comment=>params[:comments][:comment])
    
    @subscribed = Plan.find(params[:comments][:plan_id])
    @challenge_url = "#{@subscribed.id}-#{@subscribed.title.parameterize}"
      
    if if @subscribed.organizers[0]
      if @subscribed.organizers[0].messaging_bucket_comment
        if @subscribed.organizers[0].id != current_user.id

          Postoffice.cc_comment(current_user.first_name, current_user.last_name, current_user.id, 
                                @subscribed.organizers[0].email, params[:comments][:comment], 
                                @subscribed.organizers[0].authentication_token, @subscribed.title,@challenge_url,"commented on").deliver
        end
      end
    end
    
    
    #find all people who signed up, and all people who have commented.  Distinct.
    @attendees = User.find_by_sql [
                                "SELECT DISTINCT users.*
                                FROM users 
                                INNER JOIN subscribed_plans ON subscribed_plans.user_id = users.id 
                                WHERE subscribed_plans.plan_id= ?
                                
                                UNION
                                
                                SELECT DISTINCT users.*
                                FROM users
                                INNER JOIN comments ON comments.user_id = users.id 
                                WHERE comments.plan_id= ?",
                                params[:comments][:plan_id], params[:comments][:plan_id]
                              ]

    for user in @attendees
      if user.messaging_bucket_comment
        if user.id != current_user.id
          if user.id != @subscribed.user.id
             Postoffice.cc_comment(current_user.first_name, current_user.last_name, current_user.id, 
                                       user.email, params[:comments][:comment], 
                                        user.authentication_token, @subscribed.title,@challenge_url,"commented on").deliver
          end
        end
      end
    end

      

    @challenge=  @subscribed
    
    render :partial=>"comments/comment_display", :locals=>{:plan=>@subscribed}
    
  end


  def initial_comment
    
    
    @subscribed = SubscribedChallenge.find(params[:id])
    
    if current_user.id == @subscribed.user_id
      @subscribed.note = params[:subscribed_challenge][:note]
      @subscribed.save!
    end
    
    render :partial=>"comments/comment_display", :locals=>{:log=>@subscribed, :source=>params[:source]}
    
    
  end



  def destroy
  end

end
