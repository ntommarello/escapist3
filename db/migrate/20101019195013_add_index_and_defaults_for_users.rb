class AddIndexAndDefaultsForUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :username
    # add_index :users, :email # already exists!

    change_column_default :users, :score, 1
    change_column_default :users, :hidden_reputation, 100
    change_column_default :users, :mod_level, 0
    change_column_default :users, :active, true
    change_column_default :users, :privacy_cc_email, true
    change_column_default :users, :privacy_allow_messages, true
  end

  def self.down
  end
end
