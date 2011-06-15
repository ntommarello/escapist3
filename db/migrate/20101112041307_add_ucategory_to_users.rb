class AddUcategoryToUsers < ActiveRecord::Migration
  def self.up
    add_column :challenges, :category_id, :integer
  end

  def self.down
    remove_column :challenges, :category_id
  end
end
