class AddPayToTicketPurchases < ActiveRecord::Migration
  def self.up
    add_column :ticket_purchases, :payer_user_id, :integer
    add_column :ticket_purchases, :user_name, :string
    add_column :ticket_purchases, :user_email, :string
  end

  def self.down
    remove_column :ticket_purchases, :user_email
    remove_column :ticket_purchases, :user_name
    remove_column :ticket_purchases, :payer_user_id
  end
end
