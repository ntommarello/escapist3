class RemoveDiffucltyFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :challenges, :difficulty
  end

  def self.down
    add_column :challenges, :difficulty, :string
  end
end