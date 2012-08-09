class AddGroupToAchievements < ActiveRecord::Migration
  def self.up
    add_column :achievements, :group, :string
  end

  def self.down
    remove_column :achievements, :group
  end
end
