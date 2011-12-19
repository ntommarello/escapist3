class AddPricemaxToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :price_max, :decimal, :scale => 2, :precision=>10
  end

  def self.down
    remove_column :plans, :price_max
  end
end
