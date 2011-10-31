class SubscribedGroup < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :group
  
  
  scope :admins, :conditions => ["admin > 0"]
  
  
end
