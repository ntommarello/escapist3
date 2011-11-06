class AddStuffToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :username, :string
    add_column :groups, :about, :text
  end

  def self.down
    remove_column :groups, :about
    remove_column :groups, :username
  end
end
