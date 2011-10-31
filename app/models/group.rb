class Group < ActiveRecord::Base
  
  has_many :plans
  has_many :watched_plans
  has_many :subscribed_groups, :dependent => :destroy
  
  
  def check_admin(user)
      @admin = SubscribedGroups.find(:first, :conditions=>["group_id= ? and user_id = ? and admin = 1",self.id, user.id])
  end
  
end
