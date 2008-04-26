class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table(:locations, :options => 'DEFAULT CHARSET=UTF8', :force => true) do |t|
      t.column :name,  :string
    end
  end

  def self.down
    drop_table :locations
  end
end
