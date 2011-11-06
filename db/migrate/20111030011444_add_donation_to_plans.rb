class AddDonationToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :enable_donations, :boolean
    add_column :plans, :donation_text, :text
    add_column :plans, :donation_suggested_amount, :decimal
  end

  def self.down
    remove_column :plans, :donation_suggested_amount
    remove_column :plans, :donation_text
    remove_column :plans, :enable_donations
  end
end
