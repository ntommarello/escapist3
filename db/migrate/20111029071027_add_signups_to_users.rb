class AddSignupsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :privacy_cc_signups, :boolean, :default => true
  end

  def self.down
    remove_column :users, :privacy_cc_signups
  end
end
