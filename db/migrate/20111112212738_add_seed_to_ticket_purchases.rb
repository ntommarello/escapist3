class AddSeedToTicketPurchases < ActiveRecord::Migration
  def self.up
    add_column :ticket_purchases, :qr_code, :string
  end

  def self.down
    remove_column :ticket_purchases, :qr_code
  end
end
