class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    has_many :questions, :class_name => 'AssessmentQuestion', :foreign_key => 'assessment_id'


    def short_rs 
        {
            title: title,
            description: description,
            passmark: passmark,
            image_url: image_url,
            ques_count: ques_count,
            is_active: true,
            created_by_id: User.all.sample.rs,
            created_at: created_at.strftime("%d/%m/%Y %H:%M"),
        }
    end
end
