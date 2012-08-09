class AddWufooToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :application_wufoo, :text
  end

  def self.down
    remove_column :plans, :application_wufoo
  end
end
