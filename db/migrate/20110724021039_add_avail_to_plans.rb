class AddAvailToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :availability, :text
    add_column :plans, :enable_date_requests, :boolean
    add_column :plans, :enable_date_poll, :boolean
  end

  def self.down
    remove_column :plans, :enable_date_poll
    remove_column :plans, :enable_date_requests
    remove_column :plans, :availability
  end
end
