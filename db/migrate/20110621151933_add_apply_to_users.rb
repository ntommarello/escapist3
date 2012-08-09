class AddApplyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :apply, :text
  end

  def self.down
    remove_column :users, :apply
  end
end
