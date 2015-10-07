class CreateUserVisits < ActiveRecord::Migration
  def change
    create_table :user_visits do |t|
      t.integer :app_id
      t.string :controller_name
      t.string :action_name
      t.integer :user_id

      t.timestamps
    end
  end
end
