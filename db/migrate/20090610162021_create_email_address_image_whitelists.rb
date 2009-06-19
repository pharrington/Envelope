class CreateEmailAddressImageWhitelists < ActiveRecord::Migration
  def self.up
    create_table :email_address_image_whitelists, :id => false do |t|
      t.string :email
      t.string :user_email, :limit => 65
      t.timestamps
    end
    add_index :email_address_image_whitelists, :user_email
    execute <<END
ALTER TABLE "email_address_image_whitelists"
ADD PRIMARY KEY ("email"),
ADD FOREIGN KEY ("user_email") REFERENCES "users" ("email")
ON UPDATE CASCADE ON DELETE CASCADE
END
  end

  def self.down
    drop_table :email_address_image_whitelists
  end
end
