class CreateAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :assessments do |t|
      t.string :title
      t.string :description
      t.string :image_url
      t.text :context
      t.integer :passmark
      t.string :status
      t.integer :ques_count
      t.boolean :is_active, default: true
      t.datetime :deleted_at
      t.references :created_by, null: true, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end
