class RemovefbuidFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :fb_user_id
    
  end

  def self.down
    add_column :users, :fb_user_id, :integer
  end
end