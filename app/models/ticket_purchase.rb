class TicketPurchase < ActiveRecord::Base
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :subscribed_plan
  belongs_to :payer, :foreign_key => 'payer_user_id', :class_name=>"User"
  
  
end
