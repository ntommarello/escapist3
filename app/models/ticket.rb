class Ticket < ActiveRecord::Base
  
  belongs_to :plan
  
  scope :sort_by_type, :order=>"ticket_type ASC, sort_order ASC"
  
  
end
