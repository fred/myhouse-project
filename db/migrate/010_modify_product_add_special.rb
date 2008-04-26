class ModifyProductAddSpecial < ActiveRecord::Migration
  def self.up
    add_column :properties, :special_tag, :boolean, :default => false
  end

  def self.down
    remove_column :properties, :special_tag
  end
end
