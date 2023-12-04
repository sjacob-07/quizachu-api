class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    has_many :questions, :class_name => 'AssessmentQuestion', :foreign_key => 'assessment_id'


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
            leaderboard_data: leaderboard_data
        }
    end

    def rs
        data = self.short_rs
        data[:questions] = self.questions.order(:order_seq).map(&:rs)
    end

    def leaderboard_data
        data = []
        uas = UserAssessment.where(assessment_id: id, is_passed: true).order(:percentage, "DESC")[0..4]
        uas.each do |ua|
            d = {
                percentage: ua.percentage,
                marks_obtained: ua.marks_obtained,
                user_details: ua.user.rs
            }

            data << d
        end
        return data
    end
end
