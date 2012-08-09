class AddMetaToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :logo_meta, :text
  end

  def self.down
    remove_column :groups, :logo_meta
  end
end
