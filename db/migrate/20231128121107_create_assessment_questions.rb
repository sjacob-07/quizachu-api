class CreateAssessmentQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_questions do |t|
      t.text :question
      t.text :question_type
      t.text :question_description

      t.boolean :model_generated
      t.datetime :generated_at
      
      t.references :assessment, null: false, foreign_key: true

      t.boolean :is_active, default: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
