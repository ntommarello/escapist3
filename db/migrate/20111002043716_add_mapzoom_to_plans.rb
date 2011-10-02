class AddMapzoomToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :map_zoom, :integer
  end

  def self.down
    remove_column :plans, :map_zoom
  end
end
