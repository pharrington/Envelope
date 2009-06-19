class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings, :id => false do |t|
      t.string :name, :limit => 40
      t.string :signature
      t.integer :emails_per_page
      t.timestamps
    end
    execute <<END
ALTER TABLE "settings" ADD COLUMN "user_email" varchar(65)
PRIMARY KEY REFERENCES "users" ("email")
ON UPDATE CASCADE ON DELETE CASCADE
END
  end

  def self.down
    drop_table :settings
  end
end
