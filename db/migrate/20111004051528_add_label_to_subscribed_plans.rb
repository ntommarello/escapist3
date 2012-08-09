class AddLabelToSubscribedPlans < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :label, :string
  end

  def self.down
    remove_column :subscribed_plans, :label
  end
end
