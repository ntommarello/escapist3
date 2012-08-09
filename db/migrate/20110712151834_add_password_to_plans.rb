class AddPasswordToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :password, :string
  end

  def self.down
    remove_column :plans, :password
  end
end
