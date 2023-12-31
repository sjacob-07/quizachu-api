class CreateUserRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role_master, null: false, foreign_key: true

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
