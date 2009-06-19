class CreateContactsImTypes < ActiveRecord::Migration
  def self.up
    create_table :contacts_im_types do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts_im_types
  end
end
