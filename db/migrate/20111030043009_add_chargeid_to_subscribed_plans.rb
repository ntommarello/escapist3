class AddChargeidToSubscribedPlans < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :charge_id, :string
  end

  def self.down
    remove_column :subscribed_plans, :charge_id
  end
end
