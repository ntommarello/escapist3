class AddRefundToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :refund_policy, :text
  end

  def self.down
    remove_column :groups, :refund_policy
  end
end
