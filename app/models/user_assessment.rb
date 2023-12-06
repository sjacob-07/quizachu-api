class UserAssessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment

    has_many :responses, :class_name => 'UserAssessmentResponse', :foreign_key => 'user_assessment_id'

    #has_many :user_assessment_responses

    def short_rs
        {
            user_assessment_id: id,
            assessment_id: self.assessment.id,
            assessment_details: self.assessment.short_rs,
            marks_obtained: marks_obtained.present? ? marks_obtained : 0,
            percentage: percentage.present? ? percentage : 0,
            attempts_taken: attempts_taken,
            is_passed: is_passed,
            started_at: started_at,
            completed_on: completed_on,
        }
    end

    def calculate_result
        a = self.assessment
        ques_count = a.ques_count
        correct_answers = UserAssessmentResponse.where(user_assessment_id: id, is_correct: true)
        perct = ((correct_answers.count.to_f/ ques_count.to_f) * 100.0).round(2)

        if perct > ua.percentage.to_i
            self.update!(marks_obtained: correct_answers.count, percentage: perct)
        end

        if self.percentage.to_i >= a.passmark.to_i && self.is_passed != true
            self.update(is_passed: true)
        elsif self.is_passed == nil
            self.update(is_passed: false)
        end
    end
    
end
