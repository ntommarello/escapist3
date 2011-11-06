class AddFaviconToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :favicon, :string
  end

  def self.down
    remove_column :groups, :favicon
  end
end
