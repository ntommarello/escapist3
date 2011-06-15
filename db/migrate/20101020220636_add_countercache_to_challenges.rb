class AddCountercacheToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :subscribed_challenges_count, :integer
  end

  def self.down
    remove_column :challenges, :subscribed_challenges_count
  end
end
