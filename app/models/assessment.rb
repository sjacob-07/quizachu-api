class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    has_many :questions, :class_name => 'AssessmentQuestion', :foreign_key => 'assessment_id'

    def rs
        data = self.short_rs
        data[:questions] = self.questions.order(:order_seq).map(&:rs)
    end

    def short_rs 
        {
            assessment_id: id,
            title: title,
            description: description,
            duration: duration,
            category: category,
            passmark: passmark,
            image_url: image_url,
            ques_count: ques_count,
            is_active: true,
            created_by_id: User.all.sample.rs,
            created_at: created_at.strftime("%d/%m/%Y %H:%M"),
        }
    end
    
    
    def long_rs 
        data = self.short_rs
        data.merge!(leaderboard_data)

        return data
    end

    

    def leaderboard_data
        data = Hash.new
        data[:leaderboard_data] = []
        uas = UserAssessment.where(assessment_id: id, is_passed: true).order("percentage DESC")[0..4]
        uas.each_with_index do |ua,i|
            d = {
                rank: i+1,
                percentage: ua.percentage,
                marks_obtained: ua.marks_obtained,
                user_details: ua.user.rs
            }

            data[:leaderboard_data] << d
        end
        return data
    end
end
