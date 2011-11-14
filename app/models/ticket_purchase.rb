class TicketPurchase < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :subscribed_plan
end
