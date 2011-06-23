class AddAdminToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :admin, :boolean
  end

  def self.down
    remove_column :hosts, :admin
  end
end
