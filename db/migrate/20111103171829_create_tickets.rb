class CreateTickets < ActiveRecord::Migration
  
  def self.up
    create_table :tickets do |t|
      t.integer :plan_id
      t.string :title
      t.string :subtitle
      t.integer :amount
      t.integer :qty
      t.integer :ticket_type
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
  
end