class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
      t.integer :plan_id
      t.integer :type
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.integer :sort_order
      t.text :caption

      t.timestamps
    end
  end

  def self.down
    drop_table :medias
  end
end
