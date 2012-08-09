class AddMediatypeToMedia < ActiveRecord::Migration
  def self.up
    add_column :medias, :media_type, :integer
    remove_column :medias, :type
  end

  def self.down
    add_column :medias, :type, :integer
    remove_column :medias, :media_type
  end
end
