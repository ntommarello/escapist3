class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.reset_slug
    
    #if achievement = Achievement.find_by_slug('early-adopter')
    #  SubscribedAchievement.create(:user => user, :achievement => achievement, :level => 1, :sort_order => 1)
    #end
    

    
    @checkdigest = DigestEmail.find_by_email(user.email)
    if @checkdigest
      @checkdigest.joined = true
      if @checkdigest.edition == 88 and @checkdigest.approved = true
        user.mod_level = 2
        user.save
      end
      @checkdigest.save
    end
    
    
    begin
  
      if @group
        source = @group
      else  
        source = nil
      end
      
      Postoffice.newmember(user, source).deliver

    rescue Exception => exc

    end


    Message.create(:user => User.first, 
                   :receiver => user, 
                   :unread_receiver => true, 
                   :deleted_receiver => false, 
                   :warned => false, 
                   :message => "Hi #{user.first_name}!  \n\nI'm the founder of #{APP_NAME}, and I'd love to hear what you think about it.  Please feel free to reach out to me if you have any thoughts or ideas.  It'll help me make this web site kick ass. :) \n\nNick")
  end
  
end
