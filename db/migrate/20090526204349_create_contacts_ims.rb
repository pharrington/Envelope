class CreateContactsIms < ActiveRecord::Migration
  def self.up
    create_table :contacts_ims do |t|
      t.string :handle, :null => false
      t.string :type, :size => 15
      t.integer :contact_id
      t.timestamps
    end
    execute "ALTER TABLE contacts_ims ADD FOREIGN KEY (type) REFERENCES im_types (type)"
  end

  def self.down
    drop_table :contacts_ims
  end
end
