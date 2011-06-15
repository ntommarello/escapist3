class AddCategoryToAchievements < ActiveRecord::Migration
  def self.up
    add_column :achievements, :category_id, :integer
  end

  def self.down
    remove_column :achievements, :category_id
  end
end
