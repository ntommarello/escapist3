class Index1 < ActiveRecord::Migration
  def self.up
    
    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org

    
    add_index :blocks, :receiver_id
    add_index :blocks, :user_id
    add_index :comments, :subscribed_challenge_id
    add_index :comments, :user_id
    add_index :dislikes, :challenge_id
    add_index :dislikes, :user_id
    add_index :subscribed_challenges, :challenge_id
    add_index :subscribed_challenges, :user_id
    add_index :achievements, :category_id
    add_index :authentications, :user_id
    add_index :challenges, :category_id
    add_index :challenges, :achievement_id
    add_index :challenges, :author_id
    add_index :subscribed_achievements, :achievement_id
    add_index :subscribed_achievements, :user_id
    add_index :likes, :subscribed_challenge_id
    add_index :likes, :user_id
  end
  
  def self.down
    remove_index :blocks, :receiver_id
    remove_index :blocks, :user_id
    remove_index :comments, :subscribed_challenge_id
    remove_index :comments, :user_id
    remove_index :dislikes, :challenge_id
    remove_index :dislikes, :user_id
    remove_index :subscribed_challenges, :challenge_id
    remove_index :subscribed_challenges, :user_id
    remove_index :achievements, :category_id
    remove_index :authentications, :user_id
    remove_index :challenges, :category_id
    remove_index :challenges, :achievement_id
    remove_index :challenges, :author_id
    remove_index :subscribed_achievements, :achievement_id
    remove_index :subscribed_achievements, :user_id
    remove_index :likes, :subscribed_challenge_id
    remove_index :likes, :user_id
  end
end
