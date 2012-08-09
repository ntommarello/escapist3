class CreateSubscribedGroups < ActiveRecord::Migration
  def self.up
    create_table :subscribed_groups do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :admin
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribed_groups
  end
end
