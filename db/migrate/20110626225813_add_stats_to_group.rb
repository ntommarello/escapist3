class AddStatsToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :statcounter, :text
  end

  def self.down
    remove_column :groups, :statcounter
  end
end
