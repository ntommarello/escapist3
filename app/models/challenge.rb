class Challenge < ActiveRecord::Base
  # include GeoKit::Mappable
  acts_as_mappable

  cattr_reader :per_page
  @@per_page = 21
  
  belongs_to :user, :foreign_key => 'author_id'
  has_many :subscribed_challenges
  has_many :plans, :dependent => :destroy
  has_many :dislikes, :dependent => :destroy
  belongs_to :achievement
  belongs_to :category
  
  before_validation :strip_whitespace

  scope :published, :conditions => { :published => true }
  
  has_attached_file :photo, attachment_attrs(
    :default_url => "/images/no_pic_b.png",
    :styles => { :thumb_50 => "50x50#", :thumb_180 => "180x135#", :thumb_214 =>"214x161#", :thumb_314 => "314x235#", :thumb_650=>"650x400#", :large => "850x500>" })



     define_index do
         # fields
         indexes :title 
         indexes :details 
        

         
         # attributes 
          has 'RADIANS(lat)', :as => :lat,  :type => :float     
          has 'RADIANS(lng)', :as => :lng,  :type => :float  
          has created_at, updated_at, published

          # properties 
          set_property :enable_star => true
          set_property :min_prefix_len => 1
          set_property :latitude_attr  => 'lat' 
          set_property :longitude_attr => 'lng' 
          set_property :field_weights  => { 'title'        => 50,
            'details'        => 10
          }
         
       end  
  
  def strip_whitespace
    self.title = title.strip
    if self.details
      self.details = details.strip
    end
    if self.location
      self.location = location.strip
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

end
