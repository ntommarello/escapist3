class SubscribedPlan < ActiveRecord::Base
  
  belongs_to :plan
  belongs_to :user
  has_many :ticket_purchases
end