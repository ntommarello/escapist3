class AddLogoToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :logo, :string
  end

  def self.down
    remove_column :groups, :logo
  end
end
