class AddShortbioToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :short_bio, :text
  end

  def self.down
    remove_column :users, :short_bio
  end
end
