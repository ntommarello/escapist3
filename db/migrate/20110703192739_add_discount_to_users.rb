class AddDiscountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referred_by, :integer
    add_column :users, :discount_active, :boolean
  end

  def self.down
    remove_column :users, :discount_active
    remove_column :users, :referred_by
  end
end
