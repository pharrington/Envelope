class AddSignatureToggleToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :signature_enabled, :boolean
  end

  def self.down
    remove_column :settings, :signature_enabled
  end
end
