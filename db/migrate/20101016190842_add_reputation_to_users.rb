class AddReputationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :hidden_reputation, :integer
  end

  def self.down
    remove_column :users, :hidden_reputation
  end
end
