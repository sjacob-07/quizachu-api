class UserAssessmentResponse < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment
    belongs_to :assessment_question
    belongs_to :user_assessment


    def result_rs
        {
            assessment_question_id: self.assessment_question.id,
            assessment_question: self.assessment_question.question,
            answers: self.assessment_question.options.map(&:preview_rs)
            user_assessment_response_id: id,
            user_assessment_respone: user_answer,
            is_answered: is_answered,
            is_correct: is_correct,
            similarity_score: similarity_score,
        }
    end
end
