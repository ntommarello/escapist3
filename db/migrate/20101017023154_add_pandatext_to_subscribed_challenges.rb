class AddPandatextToSubscribedChallenges < ActiveRecord::Migration
  def self.up
    add_column :subscribed_challenges, :panda_video_id, :string
  end

  def self.down
    remove_column :subscribed_challenges, :panda_video_id
  end
end
