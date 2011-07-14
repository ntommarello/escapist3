class AddDiscountagainToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :enable_discount, :boolean
  end

  def self.down
    remove_column :plans, :enable_discount
  end
end
