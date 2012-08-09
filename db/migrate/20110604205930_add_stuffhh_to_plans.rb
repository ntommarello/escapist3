class AddStuffhhToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :url_link, :string
    add_column :plans, :url_name, :string
  end

  def self.down
    remove_column :plans, :url_name
    remove_column :plans, :url_link
  end
end
