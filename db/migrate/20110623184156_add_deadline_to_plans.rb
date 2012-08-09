class AddDeadlineToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :application_deadline, :date
  end

  def self.down
    remove_column :plans, :application_deadline
  end
end
