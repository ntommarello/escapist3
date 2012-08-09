class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username
      t.string :location_city
      t.float :lat
      t.float :lng
      t.string :avatar_file_name
      t.string :avatar_content_size
      t.integer :avatar_file_size
      t.integer :score
      t.boolean :privacy_allow_messages
      t.boolean :privacy_cc_email
      t.string :source
      t.text :about_me
      t.integer :mod_level

      t.timestamps
      
      t.database_authenticatable :null => false
      t.token_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    
  end
end
