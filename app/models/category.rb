class Category < ActiveRecord::Base
  
  has_many :achievements
  
  has_many :categories
  
  validates_presence_of :name
  
end