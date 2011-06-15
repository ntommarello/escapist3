class AddTitleToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :title, :string
  end

  def self.down
    remove_column :plans, :title
  end
end
