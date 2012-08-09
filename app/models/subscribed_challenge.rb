class SubscribedChallenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge, :counter_cache => true
  
  has_many :likes, :dependent => :destroy
  attr_accessor :image_url

  scope :completed, :conditions => { :completed => true }
  scope :bucket_list, :conditions => { :completed => false }
  scope :include_challenge, :include=>:challenge
  
  has_attached_file :proof, attachment_attrs(
    :default_url => "/images/generate_thumb.png",
    :styles => { :thumb_50 => "50x50#", :thumb_180 => "180x135#", :thumb_214 =>"214x161#", :thumb_314 => "314x235#", :thumb_650=>"650x400#", :large => "850x500>" })
end
