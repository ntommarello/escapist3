class AddStuffToProof < ActiveRecord::Migration
  def self.up
    add_column :subscribed_challenges, :panda_video_id, :integer
    add_column :subscribed_challenges, :date_completed_on, :datetime
    add_column :subscribed_challenges, :points_awarded, :integer
  end

  def self.down
    remove_column :subscribed_challenges, :points_awarded
    remove_column :subscribed_challenges, :date_completed_on
    remove_column :subscribed_challenges, :panda_video_id
  end
end
