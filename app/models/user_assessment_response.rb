class UserAssessmentResponse < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment
    belongs_to :assessment_question
    belongs_to :user_assessment
end
