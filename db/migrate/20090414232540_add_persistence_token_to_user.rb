class AddPersistenceTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string, :null => false
  end

  def self.down
    remove_column :users, :persistence_token
  end
end
