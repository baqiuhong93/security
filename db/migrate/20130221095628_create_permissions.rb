class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name
      t.string :description
      t.string :controller_name
      t.string :action_name
      t.string :http_method
      t.string :query_string

      t.timestamps
    end
  end


  def self.down
    drop_table :permissions
  end
end
