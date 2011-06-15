class AddLocsToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :location, :string
    add_column :plans, :lat, :float
    add_column :plans, :lng, :float
    add_column :plans, :transportation, :text
  end

  def self.down
    remove_column :plans, :transportation
    remove_column :plans, :lng
    remove_column :plans, :lat
    remove_column :plans, :location
  end
end
