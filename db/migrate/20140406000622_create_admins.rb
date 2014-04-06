class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :prof_id
      t.string :email
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end
  end
end
