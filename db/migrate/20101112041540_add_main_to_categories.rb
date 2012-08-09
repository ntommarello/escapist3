class AddMainToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :highlighted, :boolean
  end

  def self.down
    remove_column :categories, :highlighted
  end
end
