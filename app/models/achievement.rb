class Achievement < ActiveRecord::Base
  slug :name, :column => :slug

  has_many :challenges
  has_many :subscribed_achievements 
  has_many :users, :through => :subscribed_achievements

  belongs_to :category
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  define_index do
       # fields
       indexes :name  
        set_property :enable_star => true
         set_property :min_prefix_len => 1
   end  
  
  

  has_attached_file :photo, attachment_attrs(
    :default_url => "/images/no_pic.png",
    :styles => { :thumb_50 => "50x50#", :thumb_90 => "90x90#", :thumb_150 => "150x150#", :thumb_350 => "350x350#" })
end