class AssessmentOption < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    belongs_to :assessment_question

    def rs
        op = (self.assessment_question.question_type == "MCQ" || self.assessment_question.question_type == "MRQ") ? option : ""
        {
            option_id: id,
            option: op,
            order_seq: order_seq,
        }
    end

end
