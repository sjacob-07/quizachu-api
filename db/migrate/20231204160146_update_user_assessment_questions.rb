class UpdateUserAssessmentQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :assessment_questions, :confidence_score, :decimal
  end
end
