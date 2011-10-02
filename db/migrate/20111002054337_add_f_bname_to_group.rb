class AddFBnameToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :fb_link, :string
  end

  def self.down
    remove_column :groups, :fb_link
  end
end
