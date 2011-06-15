class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :user_id
      t.integer :reciever_id
      t.text :message
      t.boolean :unread_reciever
      t.boolean :deleted_reciever
      t.boolean :warned

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
