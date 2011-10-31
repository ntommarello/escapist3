class Plan < ActiveRecord::Base
  has_many :hosts
  belongs_to :group
  belongs_to :user, :foreign_key => 'host_id'
  has_many :users, :through => :subscribed_plans
  has_many :subscribed_plans, :dependent => :destroy

  has_many :comments, :dependent => :destroy
  has_many :organizers, :through => :hosts, :source => :user
  
  has_many :watched_plans
  has_many :medias
  
  scope :public_published, :conditions => ["published = ? and privacy = ?",true,1]
  scope :published, :conditions => ["published = ?",true]
   scope :sort_group, :select=>"start_time >= '#{Time.local(Time.zone.now.year, Time.zone.now.month, Time.zone.now.day, 0, 0)}' AS after, start_time IS NULL AS isnull", :order=>"group_id DESC, published ASC, isnull ASC, after desc, start_time ASC"
   scope :sort_time, :select=>"plans.*, start_time >= '#{Time.local(Time.zone.now.year, Time.zone.now.month, Time.zone.now.day, 0, 0)}' AS after, start_time IS NULL AS isnull", :order=>"published ASC, isnull ASC, after desc, start_time ASC"


   
   named_scope :filter_group, lambda { |my_id|
   { :conditions => ["group_id = ?", my_id] }
   }
   
  
  scope :not_grouped, :conditions => ["group_id is null"]
   
   
   
  acts_as_mappable
  
  def has_signedup?(user)
    subscribed_plans.find(:first, :conditions=>["user_id=?",user.id])
  end
  
  def has_maybed?(user)
    subscribed_plans.find(:first, :conditions=>["user_id=? and maybe = 1",user.id])
  end
  
  def has_soldout
    seats_remaining <= 0
  end

  

  def seats_remaining
    sum_guests = self.subscribed_plans.find(:all, :select=>"SUM(num_guests) as guests", :conditions => [" plan_id=?", self.id], :group => "subscribed_plans.plan_id")
    
    if !self.attendance_cap
      cap = 999
    else
      cap = self.attendance_cap
    end
    counter = cap - self.hosts.length - subscribed_plans.count(:conditions => [" plan_id=?", self.id])
    if sum_guests[0]
      counter = counter - sum_guests[0].guests.to_i
    end
    counter.to_i
  
  end
  
  def signups
    sum_guests = self.subscribed_plans.find(:all, :select=>"SUM(num_guests) as guests", :conditions => [" plan_id=?", self.id], :group => "subscribed_plans.plan_id")
    counter = subscribed_plans.count(:conditions => [" plan_id=?", self.id]) + self.hosts.length 
    if sum_guests[0]
      counter = counter +sum_guests[0].guests.to_i
    end
    counter.to_i
  end
  
  
  def total_amount_earned
    sum_guests = self.subscribed_plans.find(:all, :select=>"SUM(amount) as sum_amount", :conditions => [" plan_id=?", self.id], :group => "subscribed_plans.plan_id")
    
    if sum_guests[0]
      return_total = sum_guests[0].sum_amount.to_f / 100
    else
      return_total = 0
    end
  end
  

  has_attached_file :image, attachment_attrs(
    :default_url => "/images/no_pic_b.png",
    :styles => { :thumb_50 => ["50x50#", :jpg], :thumb_180 => ["180x50#", :jpg] , :thumb_400=> ["400x256#", :jpg],:thumb_600=> ["600x400#", :jpg], :thumb_1250=>["1250x1250>", :jpg]  },
    :convert_options => { :thumb_50 => '-quality 80', :thumb_180 => '-quality 80', :thumb_50 => '-quality 70',:thumb_600 => '-quality 80', :thumb_1250 => '-quality 50' }
    )

  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def custom_comment
    read_attribute(:custom_comment) ||  "Ask a Question"
  end
  
  def map_zoom
    read_attribute(:map_zoom) ||  14
  end
  
  def grab_url
    
    url = "http://#{APP_URL}/?id=#{self.id}"
    if self.group
      if self.group.url and self.group.url != ""
        url = "http://#{self.group.url}/"
      end
    end
      
    return url
    
  end
  
  
  def strip_title
    if self.title
      return self.title.gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<\s*br\s*\/?>/i,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ').gsub("<div>"," ").gsub("</div>"," ")
    else
      return ""
    end
  end
  def strip_location
    if self.title
      return self.location.gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<\s*br\s*\/?>/i,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ').gsub("<div>"," ").gsub("</div>"," ")
    else
      return ""
    end
  end
  def strip_short_desc
    if self.title
      return self.short_desc.gsub(/%3Cbr%3E/,' ').gsub(/%20/,' ').gsub(/<\s*br\s*\/?>/i,' ').gsub(/&nbsp;/,' ').gsub(/%26nbsp;/, ' ').gsub("<div>"," ").gsub("</div>"," ")
    else
      return ""
    end
  end
  
  
  

end
