class CreatePermissionsRolesJoinTable < ActiveRecord::Migration
  def up
    create_table :permissions_roles do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps
    end
  end

  def down
    drop_table :permissions_roles
  end
end
