class AddDonationToSubscribedPlans < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :donation, :integer
  end

  def self.down
    remove_column :subscribed_plans, :donation
  end
end
