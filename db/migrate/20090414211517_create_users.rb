class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :id => false do |t|
      t.string :email, :limit => 65, :null => false
      t.timestamps
    end
    primary_key =
      "ALTER TABLE users " +
      "ADD PRIMARY KEY (email)"
    execute(primary_key)
  end

  def self.down
    drop_table :users
  end
end
