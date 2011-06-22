class AddApplyToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :application_required, :boolean
  end

  def self.down
    remove_column :plans, :application_required
  end
end
