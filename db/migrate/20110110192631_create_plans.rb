class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :challenge_id
      t.boolean :featured
      t.integer :privacy
      t.integer :host_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :attendance_cap
      t.text :note
      t.integer :subscribed_plans_count

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
