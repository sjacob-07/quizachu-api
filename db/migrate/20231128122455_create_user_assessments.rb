class CreateUserAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :user_assessments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true
      t.integer :marks_obtained
      t.integer :percentage
      t.integer :attempts_taken
      t.boolean :is_passed
      t.integer :time_taken
      
      t.datetime :started_at
      t.datetime :completed_on
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
