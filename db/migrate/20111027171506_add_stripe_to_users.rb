class AddStripeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :stripe_id, :string
  end

  def self.down
    remove_column :users, :stripe_id
  end
end
