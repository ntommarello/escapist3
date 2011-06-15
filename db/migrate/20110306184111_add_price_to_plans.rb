class AddPriceToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :price, :decimal
  end

  def self.down
    remove_column :plans, :price
  end
end
