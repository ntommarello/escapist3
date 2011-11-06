
class Media < ActiveRecord::Base
  belongs_to :plan


  has_attached_file :photo, attachment_attrs(
    :default_url => "/images/no_pic_b.png",
    :styles => { :thumb_100 => ["100x67#", :jpg], :thumb_600 => ["600x400#", :jpg]  },
    :convert_options => { :thumb_100 => '-quality 80', :thumb_600 => '-quality 80' }
    )
    
    
end
