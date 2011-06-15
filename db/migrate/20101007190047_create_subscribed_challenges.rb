class CreateSubscribedChallenges < ActiveRecord::Migration
  def self.up
    create_table :subscribed_challenges do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.text :note
      t.datetime :goal_date
      t.datetime :completed_date
      t.boolean :completed
      t.string :proof_file_name
      t.string :proof_content_type
      t.integer :proof_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribed_challenges
  end
end
