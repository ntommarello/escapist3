class CreateDigestEmails < ActiveRecord::Migration
  def self.up
    create_table :digest_emails do |t|
      t.string :email
      t.integer :edition
      t.boolean :joined

      t.timestamps
    end
  end

  def self.down
    drop_table :digest_emails
  end
end
