class AddStripeToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :stripe_public, :string
    add_column :groups, :stripe_private, :string
  end

  def self.down
    remove_column :groups, :stripe_private
    remove_column :groups, :stripe_public
  end
end
