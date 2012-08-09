class CreateSubscribedPlans < ActiveRecord::Migration
  def self.up
    create_table :subscribed_plans do |t|
      t.integer :plan_id
      t.integer :user_id
      t.integer :num_guests

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribed_plans
  end
end
