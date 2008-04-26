class CreatePropertyTypes < ActiveRecord::Migration
  def self.up
    create_table(:property_types, :options => 'DEFAULT CHARSET=UTF8', :force => true) do |t|
      t.column :name,  :string
    end
  end

  def self.down
    drop_table :property_types
  end
end
