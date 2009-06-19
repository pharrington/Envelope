class CreateUidImageWhitelists < ActiveRecord::Migration
  def self.up
    create_table :uid_image_whitelists, :id => false do |t|
      t.integer :uid
      t.string :user_email, :limit => 65
      t.timestamps
    end
    add_index :uid_image_whitelists, :user_email
    execute <<END
ALTER TABLE "uid_image_whitelists"
ADD PRIMARY KEY ("uid"),
ADD FOREIGN KEY ("user_email") REFERENCES "users" ("email")
ON UPDATE CASCADE ON DELETE CASCADE
END
  end

  def self.down
    drop_table :uid_image_whitelists
  end
end
