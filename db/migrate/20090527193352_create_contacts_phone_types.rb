class CreateContactsPhoneTypes < ActiveRecord::Migration
  def self.up
    create_table :contacts_phone_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts_phone_types
  end
end
