class AddRemoteToSubscribedChallenges < ActiveRecord::Migration
  def self.up
    add_column :subscribed_challenges, :proof_remote_url, :string
  end

  def self.down
    remove_column :subscribed_challenges, :proof_remote_url
  end
end
