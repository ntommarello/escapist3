class AddDiscountToSubscribedPlan < ActiveRecord::Migration
  def self.up
    add_column :subscribed_plans, :discount, :integer
    add_column :subscribed_plans, :discount_code, :string
  end

  def self.down
    remove_column :subscribed_plans, :discount_code
    remove_column :subscribed_plans, :discount
  end
end
