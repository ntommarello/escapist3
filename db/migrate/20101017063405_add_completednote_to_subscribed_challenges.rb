class AddCompletednoteToSubscribedChallenges < ActiveRecord::Migration
  def self.up
    add_column :subscribed_challenges, :completed_note, :text
  end

  def self.down
    remove_column :subscribed_challenges, :completed_note
  end
end
