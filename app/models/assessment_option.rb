class AssessmentOption < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    belongs_to :assessment_question

end
