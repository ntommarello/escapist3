class AddFbToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :fb_id, :string
    add_column :groups, :fb_key, :string
    add_column :groups, :fb_secret, :string
  end

  def self.down
    remove_column :groups, :fb_secret
    remove_column :groups, :fb_key
    remove_column :groups, :fb_id
  end
end
