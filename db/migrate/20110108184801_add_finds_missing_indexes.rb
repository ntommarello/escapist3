class AddFindsMissingIndexes < ActiveRecord::Migration
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
  
    add_index :messages, :id
    add_index :blocks, :id
    add_index :comments, :id
    add_index :invites, :id
    add_index :deleted_users, :id
    add_index :dislikes, :id
    add_index :subscribed_challenges, :id
    add_index :achievements, :id
    add_index :achievements, :name
    add_index :authentications, :id
    add_index :authentications, [:provider, :uid]
    add_index :authentications, [:uid, :provider]
    add_index :categories, :id
    add_index :users, :id
    add_index :users, :authentication_token
    # add_index :users, :email
    # add_index :users, :username
    add_index :subscribed_achievements, :id
    add_index :challenges, :id
    add_index :likes, :id
  end

  def self.down
    remove_index :messages, :id
    remove_index :blocks, :id
    remove_index :comments, :id
    remove_index :invites, :id
    remove_index :deleted_users, :id
    remove_index :dislikes, :id
    remove_index :subscribed_challenges, :id
    remove_index :achievements, :id
    remove_index :achievements, :name
    remove_index :authentications, :id
    remove_index :authentications, :column => [:provider, :uid]
    remove_index :authentications, :column => [:uid, :provider]
    remove_index :categories, :id
    remove_index :users, :id
    remove_index :users, :authentication_token
    # remove_index :users, :email
    # remove_index :users, :username
    remove_index :subscribed_achievements, :id
    remove_index :challenges, :id
    remove_index :likes, :id
  end
end
