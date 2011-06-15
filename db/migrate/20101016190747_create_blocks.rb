class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :user_id
      t.integer :receiver_id
      t.boolean :flag
      t.text :flag_reason

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
