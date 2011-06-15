class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      
      t.integer :author_id
      t.string :title
      t.text :details
      t.boolean :editor_pick
      t.string :location
      t.float :lat
      t.float :lng
      t.integer :points
      t.integer :difficulty
      t.integer :budget
      t.integer :city
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.integer :achievement_id
      t.integer :sum_todo_list
      t.integer :sum_completed
      t.string :proof

      t.timestamps
    end
  end

  def self.down
    drop_table :challenges
  end
end
