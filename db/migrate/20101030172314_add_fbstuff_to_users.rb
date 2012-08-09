class AddFbstuffToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :website_link, :string
    add_column :users, :facebook_link, :string
    add_column :users, :gender, :int
    add_column :users, :birthday, :datetime
  end

  def self.down
    remove_column :users, :birthday
    remove_column :users, :gender
    remove_column :users, :facebook_link
    remove_column :users, :website_link
  end
end
