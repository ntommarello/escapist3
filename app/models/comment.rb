class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribed_plan, :touch => :updated_at  
end
