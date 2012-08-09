class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribed_challenge, :touch => :updated_at  
end
