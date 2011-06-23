class User < ActiveRecord::Base
  include GeoKit::Mappable
  acts_as_mappable

  slug :full_name, :column => :username
  
  has_many :subscribed_challenges, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :dislikes, :dependent => :destroy
  has_many :challenges, :through => :subscribed_challenges 

  
  has_many :authentications
    
  has_many :subscribed_achievements 
  has_many :achievements, :through => :subscribed_achievements
  
  has_many :received_messages, :class_name => 'Message', :foreign_key => :receiver_id, :dependent => :destroy
  has_many :sent_messages, :class_name => 'Message', :dependent => :destroy

  alias :messages :received_messages
  
  has_many :challenges_authored, :class_name => 'Challenge', :foreign_key => :author_id

  has_many :plans, :dependent => :destroy
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
    :styles => { :thumb_40 => ["40x40#"], :thumb_50 => ["50x50#"], :thumb_90 => ["90x90#"], :thumb_150 => ["150x150#"], :thumb_350 => ["350x350#"] },
    :convert_options => { :all => '-quality 75' }
    )
 
 

   
 
 
 
  scope :active, :conditions => ["active = ? and hidden_reputation > ?",true,50]
  
  scope :sort_photos_first, :select=> "users.*, users.avatar_file_name IS NULL AS isnull", :order => "isnull ASC"
  
  
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
    self.last_name = last_name.capitalize
    set_slug  
  end
  
  def strip_whitespace
    self.about_me = self.about_me.strip
  end
  

  
  
end
