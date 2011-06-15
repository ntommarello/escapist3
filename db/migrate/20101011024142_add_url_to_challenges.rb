class AddUrlToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :url_name, :string
    add_column :challenges, :url_link, :string
  end

  def self.down
    remove_column :challenges, :url_link
    remove_column :challenges, :url_name
  end
end
