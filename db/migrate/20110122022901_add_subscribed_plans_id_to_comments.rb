class AddSubscribedPlansIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :plan_id, :integer
    remove_column :comments, :subscribed_challenge_id
    
  end

  def self.down
    add_column :comments, :subscribed_challenge_id, :integer
    remove_column :comments, :plan_id
  end
end
