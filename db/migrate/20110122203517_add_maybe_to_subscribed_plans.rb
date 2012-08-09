class AddMaybeToSubscribedPlans < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :maybe, :boolean
  end

  def self.down
    remove_column :subscribed_plans, :maybe
  end
end
