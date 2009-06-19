class AddForeignKeysToContacts < ActiveRecord::Migration
  def self.up
    execute <<END
ALTER TABLE "contacts" ADD COLUMN "user" varchar(65) NOT NULL,
ADD FOREIGN KEY ("user") REFERENCES "users" ("email")
ON UPDATE CASCADE ON DELETE CASCADE
END
  end

  def self.down
    execute 'ALTER TABLE "contacts" DROP COLUMN "user"'
  end
end
