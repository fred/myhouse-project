class AddLocationCss < ActiveRecord::Migration
  def self.up
    add_column :locations, :top_position, :integer, :default => 0
    add_column :locations, :left_position, :integer, :default => 0
    add_column :settings, :map_image, :string
  end

  def self.down
    remove_column :locations, :top_position
    remove_column :locations, :left_position
    remove_column :settings,  :map_image
  end
end
