class CreateStates < ActiveRecord::Migration
  def self.up
    create_table(:states, :options => 'DEFAULT CHARSET=UTF8', :force => true) do |t|
      t.column :name,  :string
    end
  end

  def self.down
    drop_table :states
  end
end
