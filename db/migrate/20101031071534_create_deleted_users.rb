class CreateDeletedUsers < ActiveRecord::Migration
  def self.up
    create_table :deleted_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :login_count
      t.datetime :account_creation
      t.text :why

      t.timestamps
    end
  end

  def self.down
    drop_table :deleted_users
  end
end
