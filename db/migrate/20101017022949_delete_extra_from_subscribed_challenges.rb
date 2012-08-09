class DeleteExtraFromSubscribedChallenges < ActiveRecord::Migration
  
  def self.up
    remove_column :subscribed_challenges, :panda_video_id
    remove_column :subscribed_challenges, :completed_date
    
  end

  def self.down
    add_column :subscribed_challenges, :panda_video_id, :integer
    add_column :subscribed_challenges, :completed_date, :datetime
  end
end
