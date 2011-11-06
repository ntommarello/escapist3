class SubscribedGroup < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :group
  
  
  scope :admins, :conditions => ["admin > 0"]
  
  
  named_scope :filter_group, lambda { |my_id|
  { :conditions => ["group_id = ?", my_id] }
  }
  
  
  

  
  
  
end
