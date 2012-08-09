class AddNetworksToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :autopost_twitter_bucket, :boolean
    add_column :users, :autopost_twitter_completed, :boolean
    add_column :users, :autopost_facebook_bucket, :boolean
    add_column :users, :autopost_facebook_completed, :boolean
    add_column :users, :messaging_weekly_email, :boolean
    
    change_column_default :users, :messaging_weekly_email, true
    
  end

  def self.down
    remove_column :users, :messaging_weekly_email
    remove_column :users, :autopost_facebook_completed
    remove_column :users, :autopost_facebook_bucket
    remove_column :users, :autopost_twitter_completed
    remove_column :users, :autopost_twitter_bucket
  end
end
