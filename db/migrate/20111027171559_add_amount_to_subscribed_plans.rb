class AddAmountToSubscribedPlans < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :amount, :integer
  end

  def self.down
    remove_column :subscribed_plans, :amount
  end
end
