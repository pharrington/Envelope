class CreateContactsPhones < ActiveRecord::Migration
  def self.up
    create_table :contacts_phones do |t|
      t.string :number, :size => 25, :null => false
      t.string :type, :size => 15
      t.integer :contact_id
      t.timestamps
    end
    execute "ALTER TABLE contacts_phones ADD FOREIGN KEY (type) REFERENCES phone_types (type)"
  end

  def self.down
    drop_table :contacts_phones
  end
end
