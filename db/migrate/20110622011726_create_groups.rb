class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :user_id
      t.text :name
      t.text :subtitle
      t.boolean :domain
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
