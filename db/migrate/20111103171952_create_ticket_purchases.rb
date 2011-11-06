class CreateTicketPurchases < ActiveRecord::Migration
  def self.up
    create_table :ticket_purchases do |t|
      t.integer :subscribed_plan_id
      t.integer :plan_id
      t.integer :user_id
      t.integer :ticket_id
      t.integer :qty
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_purchases
  end
end
