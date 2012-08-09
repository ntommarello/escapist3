class AddTwitterlinkToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_link, :string
  end

  def self.down
    remove_column :users, :twitter_link
  end
end
