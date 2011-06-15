class AddSlugToAchievements < ActiveRecord::Migration
  def self.up
    add_column :achievements, :slug, :string
  end

  def self.down
    remove_column :achievements, :slug
  end
end
