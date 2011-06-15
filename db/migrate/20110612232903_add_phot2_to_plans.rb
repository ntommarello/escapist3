class AddPhot2ToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :image_file_name, :string
    add_column :plans, :image_file_size, :integer
    add_column :plans, :image_content_type, :string
  end

  def self.down
    remove_column :plans, :image_content_type
    remove_column :plans, :image_file_size
    remove_column :plans, :image_file_name
  end
end
