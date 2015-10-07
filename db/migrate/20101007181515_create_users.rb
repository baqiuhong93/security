class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,              :null => false, :default => ""

      t.boolean :admin, :default => false
      t.string :name
      t.string :last_name
      t.boolean :admin
      t.string :salt, :limit => 10

      t.timestamps
    end

    add_index :users, :email,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
