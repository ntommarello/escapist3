class Ticket < ActiveRecord::Base
  
  belongs_to :plan
  
  has_many :ticket_purchase
  
  scope :sort_by_type, :conditions=>["soft_delete = ? || soft_delete is null",0], :order=>"ticket_type ASC, sort_order ASC"
  
  scope :filter_by_ticket, :conditions=>["ticket_type = 1 and (soft_delete = ? || soft_delete is null)",false], :order=>"sort_order ASC"
  scope :filter_by_addon, :conditions=>["ticket_type = 2 and (soft_delete = ? || soft_delete is null)",0], :order=>"sort_order ASC"
  
end
