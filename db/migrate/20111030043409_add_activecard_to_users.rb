class AddActivecardToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_card, :string
  end

  def self.down
    remove_column :users, :active_card
  end
end
