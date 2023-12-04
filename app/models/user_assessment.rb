class UserAssessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment

    has_many :user_assessment_responses

    def short_rs
        {
            user_assessment_id: id,
            assessment_id: self.assessment.id,
            assessment_details: self.assessment.short_rs
            marks_obtained: marks_obtained,
            percentage: percentage,
            attempts_taken: attempts_taken,
            is_passed: is_passed,
            started_at: started_at,
            completed_on: completed_on,
        }
    end
end
