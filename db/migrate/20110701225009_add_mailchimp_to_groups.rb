class AddMailchimpToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :mailchimp_key, :string
    add_column :groups, :mailchimp_list, :string
  end

  def self.down
    remove_column :groups, :mailchimp_list
    remove_column :groups, :mailchimp_key
  end
end
