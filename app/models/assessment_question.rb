class AssessmentQuestion < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    belongs_to :assessment
    has_many :options, :class_name => 'AssessmentOption', :foreign_key => 'assessment_question_id'
end
