class AddSmallpicToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :small_twitter_pic, :boolean
  end

  def self.down
    remove_column :users, :small_twitter_pic
  end
end
