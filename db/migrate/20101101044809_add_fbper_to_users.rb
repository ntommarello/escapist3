class AddFbperToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_extended_permissions, :boolean
  end

  def self.down
    remove_column :users, :fb_extended_permissions
  end
end
