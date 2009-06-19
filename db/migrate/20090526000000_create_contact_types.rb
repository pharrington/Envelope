class CreateContactTypes < ActiveRecord::Migration
  TABLES = [:email_types, :phone_types, :address_types, :im_types]
  def self.up
    TABLES.each do |table|
      create_table table, :id => false do |t|
        t.string :type, :size => 15
      end
      execute "ALTER TABLE #{table.to_s} ADD PRIMARY KEY (type)"
    end
    execute <<END
INSERT INTO email_types VALUES
  ('Work'),
  ('Personal'),
  ('Other')
END
    execute <<END
INSERT INTO phone_types VALUES
  ('Work'),
  ('Mobile'),
  ('Fax'),
  ('Home'),
  ('Other')
END
    execute <<END
INSERT INTO address_types VALUES
  ('Work'),
  ('Home'),
  ('Other')
END
    execute <<END
INSERT INTO im_types VALUES
  ('AIM'),
  ('Yahoo'),
  ('Google Talk'),
  ('MSN'),
  ('Jabber'),
  ('ICQ'),
  ('Other')
END
  end

  def self.down
    TABLES.each {|t| drop_table t}
  end
end
