require "uri"
require "json"
require "net/http"

namespace :assessments do
    # task generate_questions: :environment do 
    #     a_ids = Assessment.where(status: "PUBLISHED").pluck(:id)
    #     aques_aids = AssessmentQuestion.all.pluck(:assessment_id).uniq

    #     a_ids = aques_aids - a_ids
    # end
    
    task evaluate_user_answer: :environment do 
        puts "#{DateTime.now}-evaluate_user_answer"
        a_ids = Assessment.where(status: "PUBLISHED").pluck(:id)
        uars = UserAssessmentResponse.where(assessment_id: a_ids, evaluated_at: nil).order(:created_at)
        puts uars.count
        uar = uars.first
        
        if uar.present? 
            uar.update(evaluated_at: DateTime.now)
            uar.evaluate_response
            uar&.user_assessment&.calculate_result
        end
        puts "------"
    end

end