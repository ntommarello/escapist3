class AddPrivaToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :privacy_block_adventure_log, :boolean
  end

  def self.down
    remove_column :users, :privacy_block_adventure_log
  end
end
