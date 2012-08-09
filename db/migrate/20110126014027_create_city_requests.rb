class CreateCityRequests < ActiveRecord::Migration
  def self.up
    create_table :city_requests do |t|
      t.string :email
      t.string :city

      t.timestamps
    end
  end

  def self.down
    drop_table :city_requests
  end
end
