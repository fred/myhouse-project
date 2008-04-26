class CreateCities < ActiveRecord::Migration
  def self.up
    create_table(:cities, :options => 'DEFAULT CHARSET=UTF8', :force => true) do |t|
      t.column :name,  :string
      t.column :state_id, :integer
    end
    add_index :cities, :state_id
  end

  def self.down
    drop_table :cities
  end
end
