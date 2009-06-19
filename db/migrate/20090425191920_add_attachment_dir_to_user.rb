class AddAttachmentDirToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :attachment_dir, :string, :limit => 12
  end

  def self.down
    remove_column :users, :attachment_dir
  end
end
