class AddGuestnameToTicketPurchases < ActiveRecord::Migration
  def self.up
    add_column :ticket_purchases, :guest_last_name, :string
    add_column :ticket_purchases, :guest_first_name, :string
  end

  def self.down
    remove_column :ticket_purchases, :guest_first_name
    remove_column :ticket_purchases, :guest_last_name
  end
end
