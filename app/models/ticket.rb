class Ticket < ActiveRecord::Base
  
  belongs_to :plan
  
  has_many :ticket_purchase
  
  scope :sort_by_type, :order=>"ticket_type ASC, sort_order ASC"
  
  
end
