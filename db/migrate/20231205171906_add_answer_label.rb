class AddAnswerLabel < ActiveRecord::Migration[6.1]
  def change
    add_column :user_assessment_responses, :answer_evaluation_label, :string
    add_column :user_assessment_responses, :probability_score, :decimal
  end
end
