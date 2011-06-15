class Defaultco < ActiveRecord::Migration
  def self.up
    change_column_default :users, :messaging_bucket_comment, true
  end

  def self.down
  end
end
