class AddWeatherToChallenges < ActiveRecord::Migration
  def self.up
    add_column :challenges, :weather, :integer
  end

  def self.down
    remove_column :challenges, :weather
  end
end
