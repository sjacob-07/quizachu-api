class AssessmentQuestion < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    belongs_to :assessment
    has_many :options, :class_name => 'AssessmentOption', :foreign_key => 'assessment_question_id'

    def rs
        {
            question_id: id,
            question: question,
            question_type: question_type,
            question_description: question_description,
            order_seq: order_seq,
            options: self.options.order(:order_seq).map(&:rs)
        }
    end

    def preview_rs
        {
            question_id: id,
            question: question,
            question_type: question_type,
            question_description: question_description,
            order_seq: order_seq,
            options: self.options.order(:order_seq).map(&:preview_rs),
            confidence_score: confidence_score.present? ? (confidence_score.to_f).round(2)  : ""
        }

    end
end
