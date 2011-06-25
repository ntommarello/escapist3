class AddTwToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :twitter, :string
    add_column :groups, :tumblr, :string
  end

  def self.down
    remove_column :groups, :tumblr
    remove_column :groups, :twitter
  end
end
