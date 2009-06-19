class CreateContactsEmails < ActiveRecord::Migration
  def self.up
    create_table :contacts_emails do |t|
      t.string :email, :null => false
      t.string :type, :size => 15
      t.integer :contact_id
      t.timestamps
    end
    execute "ALTER TABLE contacts_emails ADD FOREIGN KEY (type) REFERENCES email_types (type)"
  end

  def self.down
    drop_table :contacts_emails
  end
end
