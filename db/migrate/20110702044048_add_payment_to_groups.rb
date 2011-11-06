class AddPaymentToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :wepay_token, :string
    add_column :groups, :wepay_group_id, :string
  end

  def self.down
    remove_column :groups, :wepay_group_id
    remove_column :groups, :wepay_token
  end
end
