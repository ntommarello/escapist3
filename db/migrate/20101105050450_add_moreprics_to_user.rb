class AddMorepricsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :privacy_achievement, :integer
    add_column :users, :privacy_bucket, :integer
    
    change_column_default :users, :privacy_achievement, 0
    change_column_default :users, :privacy_bucket, 0
    
    
  end

  def self.down
    remove_column :users, :privacy_bucket
    remove_column :users, :privacy_achievement
  end
end
