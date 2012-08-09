class AddPlanoffToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :discount_enabled, :boolean
  end

  def self.down
    remove_column :plans, :discount_enabled
  end
end
