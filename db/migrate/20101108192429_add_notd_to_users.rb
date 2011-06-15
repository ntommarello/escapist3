class AddNotdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :messaging_bucket_comment, :boolean
  end

  def self.down
    remove_column :users, :messaging_bucket_comment
  end
end
