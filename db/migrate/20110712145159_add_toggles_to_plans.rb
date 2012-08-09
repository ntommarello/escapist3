class AddTogglesToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :enable_comments, :boolean
    add_column :plans, :enable_sharing, :boolean
    add_column :plans, :enable_signups, :boolean
  end

  def self.down
    remove_column :plans, :enable_signups
    remove_column :plans, :enable_sharing
    remove_column :plans, :enable_comments
  end
end
