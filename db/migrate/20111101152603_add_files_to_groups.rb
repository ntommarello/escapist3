class AddFilesToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :favicon_file_name, :string
    add_column :groups, :favicon_content_type, :string
    add_column :groups, :favicon_file_size, :integer
    add_column :groups, :logo_file_name, :string
    add_column :groups, :logo_content_type, :string
    add_column :groups, :logo_file_size, :integer
  end

  def self.down
    remove_column :groups, :logo_file_size
    remove_column :groups, :logo_content_type
    remove_column :groups, :logo_file_name
    remove_column :groups, :favicon_file_size
    remove_column :groups, :favicon_content_type
    remove_column :groups, :favicon_file_name
  end
end
