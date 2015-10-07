class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.integer :app_id
      t.integer :menu_id
      t.integer :order_num

      t.timestamps
    end
  end

  def self.down
  	drop_table :roles
  end
end
