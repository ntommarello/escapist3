class Group < ActiveRecord::Base
  
  has_many :plans
  has_many :watched_plans
  has_many :subscribed_groups, :dependent => :destroy
  
  has_attached_file :logo, attachment_attrs(
    :default_url => "",
    :styles => { :header => ["400x44>", :png], :square => ["100x100#", :png]  }
    )
  
  has_attached_file :favicon, attachment_attrs(
      :default_url => "",
      :styles => { :thumb_16 => ["16x16#"] }
  )
  
  
  
  def check_admin(user)
      @admin = SubscribedGroup.find(:first, :conditions=>["group_id= ? and user_id = ? and admin = 1",self.id, user.id])
  end
  
end
