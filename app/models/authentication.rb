class Authentication < ActiveRecord::Base
  
  belongs_to :user
  
  scope :facebook, :conditions => "provider='facebook'"
  scope :twitter, :conditions => "provider='twitter'"
  
end
