class AddPublishedToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :published, :boolean
  end

  def self.down
    remove_column :challenges, :published
  end
end
