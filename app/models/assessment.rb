class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    has_many :questions, :class_name => 'AssessmentQuestion', :foreign_key => 'assessment_id'
end
