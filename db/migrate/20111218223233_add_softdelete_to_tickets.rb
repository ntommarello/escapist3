class AddSoftdeleteToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :soft_delete, :boolean
  end

  def self.down
    remove_column :tickets, :soft_delete
  end
end
