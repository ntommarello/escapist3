class AddCustomcommentToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :custom_comment, :string
  end

  def self.down
    remove_column :plans, :custom_comment
  end
end
