class CreateContactsEmailTypes < ActiveRecord::Migration
  def self.up
    create_table :contacts_email_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts_email_types
  end
end
