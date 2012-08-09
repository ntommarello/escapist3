class AddLocToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :short_location, :string
    add_column :plans, :short_desc, :string
  end

  def self.down
    remove_column :plans, :short_desc
    remove_column :plans, :short_location
  end
end
