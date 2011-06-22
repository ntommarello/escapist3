class DeleteStuffFromPlans < ActiveRecord::Migration
  
  def self.up
    remove_column :plans, :challenge_id
    remove_column :plans, :subscribed_plans_count
    add_column :plans, :group_id, :integer
  end

  def self.down
    add_column :plans, :apply, :integer
    add_column :plans, :subscribed_plans_count, :integer
    remove_column :plans, :group_id
  end
  
end