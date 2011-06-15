class CreateSubscribedAchievements < ActiveRecord::Migration
  def self.up
    create_table :subscribed_achievements do |t|
      t.integer :user_id
      t.integer :achievement_id
      t.integer :level
      t.integer :sort_order

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribed_achievements
  end
end
