class User < ActiveRecord::Base
  include GeoKit::Mappable
  acts_as_mappable

  has_many :watched_plans 
  has_many :ticket_purchases

  slug :full_name, :column => :username
  
  has_many :subscribed_challenges, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :dislikes, :dependent => :destroy
  has_many :challenges, :through => :subscribed_challenges 
  has_many :subscribed_groups, :dependent => :destroy
  
  has_many :authentications
    
  has_many :subscribed_achievements 
  has_many :achievements, :through => :subscribed_achievements
  
  has_many :received_messages, :class_name => 'Message', :foreign_key => :receiver_id, :dependent => :destroy
  has_many :sent_messages, :class_name => 'Message', :dependent => :destroy

  alias :messages :received_messages
  
 
  has_many :hosts
  has_many :tickets_purchased, :class_name => 'TicketPurchase', :foreign_key => :payer_user_id
  
  has_many :plans_authored, :through => :hosts, :source => :plan


  has_many :subscribed_plans, :dependent => :destroy
  
  has_many :blocks, :dependent => :destroy
  has_many :blocked_users, :through => :blocks
   
  devise :database_authenticatable, :registrable, :token_authenticatable,
         :recoverable, :rememberable, :trackable

 # before_validation :reset_slug  - causes to increment every name name is saved. yuck
  before_validation :strip_whitespace
  before_save :ensure_authentication_token
  before_save :capitalize_names

  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  
  has_attached_file :avatar, attachment_attrs(
    :default_url => "/images/no_avatar.png",
    :styles => { :thumb_40 => ["40x40#"], :thumb_50 => ["50x50#"], :rounded_90 => ["90x90#", :png], :rounded_50 => ["50x50#", :png], :thumb_90 => ["90x90#"], :thumb_150 => ["150x150#"], :thumb_350 => ["350x350#"] },
    :convert_options => { :all => '-quality 75', :rounded_90 => Proc.new{self.convert_options}, :rounded_50 => Proc.new{self.convert_options} }
    )
 
  scope :active, :conditions => ["active = ? and hidden_reputation > ?",true,50]
  
  scope :sort_photos_first, :select=> "users.*, users.avatar_file_name IS NULL AS isnull", :order => "isnull ASC"
  
  scope :limiteight, :limit=>"8"
  
  define_index do
      # fields
      indexes :first_name 
      indexes :last_name 
      indexes :about_me 

      
      # attributes 
       has 'RADIANS(lat)', :as => :lat,  :type => :float     
       has 'RADIANS(lng)', :as => :lng,  :type => :float  
       has created_at, updated_at

       # properties 
       set_property :enable_star => true
       set_property :min_prefix_len => 1
       set_property :latitude_attr  => 'lat' 
       set_property :longitude_attr => 'lng' 
       set_property :field_weights  => { 'last_name'        => 100, 'first_name'        => 50,
         'about_me'        => 10
       }
      
    end
    
    
  
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def about_me
    read_attribute(:about_me) ||  "I'm new, so I haven't filled out my bio yet!"
  end

  def unread_messages
    received_messages.unread
  end

  def current_inbox
    sql = ["SELECT *, conversations.unread_receiver as unread, conversations.created_at as created_at 
          FROM (SELECT id as messageid, message, created_at, unread_receiver, deleted_receiver, user_id, receiver_id from messages 
                ORDER BY created_at DESC) AS conversations 
          JOIN users ON conversations.user_id = users.id WHERE conversations.receiver_id = ? and deleted_receiver = ?
          GROUP BY user_id 
          ORDER BY conversations.unread_receiver DESC, conversations.created_at DESC LIMIT 0, 100", id, false]
    Message.find_by_sql(sql)
  end
  
  def bucket_count
    count = SubscribedChallenge.find(:all, :conditions=> ["completed=? and user_id=?", false, id])
    return count.length
  end
  
  def my_challenge_count
    count = Challenge.find(:all, :conditions=> ["author_id=?", id])
    return count.length
  end
  
  def has_watched?(plan)
    if plan.group_id
      watched_plans.find(:first, :conditions=>["group_id=?",plan.group_id])
    else
      watched_plans.find(:first, :conditions=>["plan_id=?",plan.id])
    end
  end
  
  

  def allow_messages_from?(user)
    # TODO: Eventually will have to check for followers/subscribers
    !!user && privacy_allow_messages && !has_blocked?(user)
  end
  
  def has_blocked?(user)
    blocks.find_by_receiver_id(user.id)
  end

  def has_saved_challenge?(challenge)
    !!subscribed_challenges.find_by_challenge_id(challenge.id)
  end
  
  def has_completed_challenge?(challenge)
    !!subscribed_challenges.completed.find_by_challenge_id(challenge.id)
  end

  private

  def capitalize_names
    self.first_name = first_name.titleize
    self.last_name = last_name.slice(0,1).capitalize + last_name.slice(1,last_name.length);
    set_slug  
  end
  
  def strip_whitespace
    self.about_me = self.about_me.strip
  end
  
  def self.convert_options
      trans = ""
      px = 5
      trans << " \\( +clone  -threshold -1 "
      trans << "-draw 'fill black polygon 0,0 0,#{px} #{px},0 fill white circle #{px},#{px} #{px},0' "
      trans << "\\( +clone -flip \\) -compose Multiply -composite "
      trans << "\\( +clone -flop \\) -compose Multiply -composite "
      trans << "\\) +matte -compose CopyOpacity -composite "
    end
  
  
end
