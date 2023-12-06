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
        uars = UserAssessmentResponse.where(assessment_id: a_ids, is_correct: nil).order(:created_at)
        puts uars.count
        uar = uars.first
        
        if uar.present?
            uar.update(is_correct: false)
            gold_answer = uar&.assessment_question&.options&.first&.option
            a = uar.assessment

            if uar.user_answer.present? && gold_answer.present?
                url = URI("https://quizachu-backend-h67ch72r3q-ew.a.run.app/score-answers")
                #url = URI(ENV["base_url"] + "generate-questions-and-answers")
                https = Net::HTTP.new(url.host, url.port)
                https.use_ssl = true
                # Set the read timeout (in seconds)
                https.read_timeout = 180  # for example, setting a 2-minute timeout

                request = Net::HTTP::Post.new(url)
                request["Content-Type"] = "application/json"
                request.body = JSON.dump({
                    "sentence1": gold_answer,
                    "sentence2": uar.user_answer,
                })

                response = https.request(request)
                if response.code.to_i == 200
                    res = JSON.parse(response.body)
                    uar.update!(
                        answer_evaluation_label: res["prediction"],
                        probability_score: res["probability"],
                        model_evaluated: true,
                        evaluated_at: DateTime.now
                    )

                    if uar.answer_evaluation_label == "entailment" && uar.probability_score.to_i >= 75
                        uar.update(
                            is_correct: true,
                        )
                    else
                        uar.update(
                            is_correct: false,
                        )
                    end
                end
            end
            ques_count = a.ques_count
            correct_answers = UserAssessmentResponse.where(user_id: uar.user_id, assessment_id: uar.assessment_id, is_correct: true)
            perct = ((correct_answers.count.to_f/ ques_count.to_f) * 100.0).round(2)

            if perct > ua.percentage.to_i
                ua.update!(marks_obtained: correct_answers.count, percentage: perct)
            end

            if ua.percentage.to_i >= a.passmark.to_i && ua.is_passed != true
                ua.update(is_passed: true)
            elsif ua.is_passed == nil
                ua.update(is_passed: false)
            end
        end
        puts "------"
    end

end