class FixSpeelingErorrs < ActiveRecord::Migration
  def self.up
    rename_column :messages, :reciever_id, :receiver_id
    rename_column :messages, :unread_reciever, :unread_receiver
    rename_column :messages, :deleted_reciever, :deleted_receiver
  end

  def self.down
    rename_column :messages, :receiver_id, :reciever_id
    rename_column :messages, :unread_receiver, :unread_reciever
    rename_column :messages, :deleted_receiver, :deleted_reciever
  end
end
