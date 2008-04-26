class RenameResourceToMessage < ActiveRecord::Migration
  def self.up
    rename_table :resources, :messages
  end

  def self.down
    rename_table :messages, :resources
  end
end
