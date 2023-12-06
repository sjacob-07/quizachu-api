class UserAssessmentResponse < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment
    belongs_to :assessment_question
    belongs_to :user_assessment


    def result_rs
        label = answer_evaluation_label.present? ? (answer_evaluation_label == "entailment" ? "Similar" : answer_evaluation_label.titleize) : "Evaluation Pending"
        {
            assessment_question_id: self.assessment_question.id,
            assessment_question: self.assessment_question.question,
            answers: self.assessment_question.options.map(&:preview_rs),
            user_assessment_response_id: id,
            user_assessment_respone: user_answer,
            is_answered: is_answered,
            is_correct: is_correct,
            answer_evaluation_label: answer_evaluation_label,
            probability_score: probability_score.present ? "#{(probability_score.to_f*100)}%" : "NA"
        }
    end
end
