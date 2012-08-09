class AddGeoToCityRequests < ActiveRecord::Migration
  def self.up
    add_column :city_requests, :lat, :float
    add_column :city_requests, :lng, :float
  end

  def self.down
    remove_column :city_requests, :lng
    remove_column :city_requests, :lat
  end
end
