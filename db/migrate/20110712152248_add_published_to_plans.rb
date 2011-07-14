class AddPublishedToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :published, :boolean
  end

  def self.down
    remove_column :plans, :published
  end
end
