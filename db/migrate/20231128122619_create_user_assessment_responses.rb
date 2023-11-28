class CreateUserAssessmentResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_assessment_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :assessment, null: false, foreign_key: true
      t.references :assessment_question, null: false, foreign_key: true

      t.string :user_answer
      t.string :user_answer_url
      t.boolean :is_answered
      t.boolean :is_correct
      t.integer :marks_obtained_for_question

      t.datetime :started_at
      t.datetime :completed_on
      t.integer :time_taken
      t.datetime :deleted_at

      t.boolean :model_evaluated
      t.datetime :evaluated_at

      t.timestamps
    end
  end
end
