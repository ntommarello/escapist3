class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reset_slug
    
    if achievement = Achievement.find_by_slug('early-adopter')
      SubscribedAchievement.create(:user => user, :achievement => achievement, :level => 1, :sort_order => 1)
    end

    Postoffice.newmember(user.email, user.authentication_token).deliver

    Message.create(:user => User.first, 
                   :receiver => user, 
                   :unread_receiver => true, 
                   :deleted_receiver => false, 
                   :warned => false, 
                   :message => "Welcome to #{APP_NAME}!  \n\nYou found out about us pretty early - consider this our alpha version.  Stuff is bound to break!  But on the plus side, if you have an idea for a feature you just need to have, there's a good chance we can code it up for you.  Just let me know!")
  end
end
