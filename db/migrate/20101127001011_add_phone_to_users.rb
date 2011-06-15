class AddPhoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_OS, :string
    add_column :users, :phone_model, :string
    add_column :users, :app_version, :string
  end

  def self.down
    remove_column :users, :app_version
    remove_column :users, :phone_model
    remove_column :users, :phone_OS
  end
end
