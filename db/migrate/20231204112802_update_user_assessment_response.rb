class UpdateUserAssessmentResponse < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_assessment_responses, :user_assessment, foreign_key: true
    add_column :user_assessment_responses, :similarity_score, :decimal
  end
end
