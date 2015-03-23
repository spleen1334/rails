class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.string "username"
      t.string "hashed_password"


      t.timestamps
    end
  end
end
