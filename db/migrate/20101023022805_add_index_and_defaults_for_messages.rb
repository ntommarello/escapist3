class AddIndexAndDefaultsForMessages < ActiveRecord::Migration
  def self.up
    change_column_default :messages, :unread_receiver, true
    change_column_default :messages, :deleted_receiver, false
    change_column_default :messages, :warned, false

    add_index :messages, :user_id
    add_index :messages, :receiver_id
  end

  def self.down
  end
end
