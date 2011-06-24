class AddStuffToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :twitter_name, :string
    add_column :groups, :custom_twitter_text, :text
  end

  def self.down
    remove_column :groups, :custom_twitter_text
    remove_column :groups, :twitter_name
  end
end
