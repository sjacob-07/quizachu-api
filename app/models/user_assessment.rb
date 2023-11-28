class UserAssessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment

    has_many :user_assessment_responses
end
