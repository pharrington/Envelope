class CreateContactsAddresses < ActiveRecord::Migration
  def self.up
    create_table :contacts_addresses do |t|
      t.text :address, :null => false
      t.string :type, :size => 15
      t.integer :contact_id
      t.timestamps
    end
    execute "ALTER TABLE contacts_addresses ADD FOREIGN KEY (type) REFERENCES address_types (type)"
  end

  def self.down
    drop_table :contacts_addresses
  end
end
