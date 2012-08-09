class AddPaypal2ToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :paypal_email, :string
  end

  def self.down
    remove_column :groups, :paypal_email
  end
end
