class AddPrivacyToSubscribedChallenges < ActiveRecord::Migration
  def self.up
    add_column :subscribed_challenges, :private, :integer
  end

  def self.down
    remove_column :subscribed_challenges, :private
  end
end
