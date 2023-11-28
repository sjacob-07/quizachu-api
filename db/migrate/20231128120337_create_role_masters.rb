class CreateRoleMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :role_masters do |t|
      t.string :name
      t.string :description
      t.boolean :is_active, default: true
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
