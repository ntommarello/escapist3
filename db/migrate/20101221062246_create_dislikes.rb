class CreateDislikes < ActiveRecord::Migration
  def self.up
    create_table :dislikes do |t|
      t.integer :user_id
      t.integer :challenge_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dislikes
  end
end
