class DeleteMstuffFromPlans < ActiveRecord::Migration
  
  def self.up
    remove_column :plans, :host_id
    remove_column :plans, :photo_file_name
    remove_column :plans, :photo_file_size
    remove_column :plans, :photo_content_type
    remove_column :plans, :discount_enabled
  end

  def self.down
    add_column :plans, :host_id, :integer
    add_column :plans, :photo_file_name, :string
    add_column :plans, :photo_file_size, :integer
    add_column :plans, :photo_content_type, :string
    add_column :plans, :discount_enabled, :boolean
  end
end
