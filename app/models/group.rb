class Group < ActiveRecord::Base
  
  has_many :plans
  has_many :watched_plans
end
