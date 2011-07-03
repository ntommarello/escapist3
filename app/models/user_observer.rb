class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reset_slug
    
    #if achievement = Achievement.find_by_slug('early-adopter')
    #  SubscribedAchievement.create(:user => user, :achievement => achievement, :level => 1, :sort_order => 1)
    #end
    

    
    @checkdigest = DigestEmail.find_by_email(user.email)
    if @checkdigest
      @checkdigest.joined = true
      @checkdigest.save
    end
    
    

    Postoffice.newmember(user.email, user.authentication_token).deliver

    Message.create(:user => User.first, 
                   :receiver => user, 
                   :unread_receiver => true, 
                   :deleted_receiver => false, 
                   :warned => false, 
                   :message => "Welcome!  \n\nI'm the founder of #{APP_NAME}, and I'd love to hear what you think about it.  Please feel free to reach out to me if you have any thoughts, ideas, or war stories.  I don't bite!  The whole reason I'm doing this is to meet more awesome people while doing fun things. :)  \n\nNick")
  end
  
end
