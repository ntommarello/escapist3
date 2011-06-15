class AddVettedToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :vetted, :boolean
  end

  def self.down
    remove_column :challenges, :vetted
  end
end
