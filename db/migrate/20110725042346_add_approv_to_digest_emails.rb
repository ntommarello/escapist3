class AddApprovToDigestEmails < ActiveRecord::Migration
  def self.up
    add_column :digest_emails, :approved, :boolean
  end

  def self.down
    remove_column :digest_emails, :approved
  end
end
