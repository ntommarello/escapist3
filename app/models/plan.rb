class Plan < ActiveRecord::Base
  has_many :hosts
  belongs_to :user, :foreign_key => 'host_id'
  has_many :users, :through => :subscribed_plans
  has_many :subscribed_plans, :dependent => :destroy
  has_many :comments, :dependent => :destroy
 # has_many :organizers, :through => :hosts, :foreign_key => 'user_id'
  has_many :organizers, :through => :hosts, :source => :user
  
  acts_as_mappable
  
  def has_signedup?(user)
    subscribed_plans.find(:first, :conditions=>["user_id=? and maybe != 1",user.id])
  end
  
  def has_maybed?(user)
    subscribed_plans.find(:first, :conditions=>["user_id=? and maybe = 1",user.id])
  end
  
  def has_soldout
    seats_remaining <= 0
  end

  def seats_remaining
    attendance_cap - 1 -subscribed_plans.count(:conditions => [" plan_id=?", self.id])
  end

  has_attached_file :image, attachment_attrs(
    :default_url => "/images/no_pic_b.png",
    :styles => { :thumb_50 => ["50x50#", :jpg], :thumb_180 => ["180x50#", :jpg] , :thumb_400=> ["400x256#", :jpg] , :thumb_1250=>["1250x1250>", :jpg]  },
    :convert_options => { :thumb_50 => '-quality 80', :thumb_180 => '-quality 80', :thumb_50 => '-quality 70', :thumb_1250 => '-quality 50' }
    )

  def to_param
    "#{id}-#{title.parameterize}"
  end
  
end
