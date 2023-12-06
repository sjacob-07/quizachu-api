class UserAssessmentResponse < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    belongs_to :user
    belongs_to :assessment
    belongs_to :assessment_question
    belongs_to :user_assessment


    def result_rs
        label = answer_evaluation_label.present? ? (answer_evaluation_label == "entailment" ? "Similar" : answer_evaluation_label.titleize) : "Evaluation Pending"
        {
            assessment_question_id: self.assessment_question.id,
            assessment_question: self.assessment_question.question,
            answers: self.assessment_question.options.map(&:preview_rs),
            user_assessment_response_id: id,
            user_assessment_respone: user_answer,
            is_answered: is_answered,
            is_correct: is_correct,
            answer_evaluation_label: label,
            probability_score: probability_score.present? ? "#{(probability_score.to_f*100)}%" : "NA"
        }
    end

    def evaluate_response
        gold_answer = self&.assessment_question&.options&.first&.option
        a = self.assessment
        ua = self.user_assessment

        if self.user_answer.present? && gold_answer.present?
            url = URI("https://quizachu-backend-h67ch72r3q-ew.a.run.app/score-answers")
            #url = URI(ENV["base_url"] + "generate-questions-and-answers")
            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            # Set the read timeout (in seconds)
            https.read_timeout = 600  # for example, setting a 2-minute timeout

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/json"
            request.body = JSON.dump({
                "sentence1": gold_answer,
                "sentence2": self.user_answer,
            })

            response = https.request(request)
            if response.code.to_i == 200
                res = JSON.parse(response.body)
                self.update!(
                    answer_evaluation_label: res["prediction"],
                    probability_score: res["probability"],
                    model_evaluated: true,
                    evaluated_at: DateTime.now
                )

                if self.answer_evaluation_label == "entailment" && self.probability_score.to_f >= 0.75
                    self.update!(is_correct: true)
                else
                    self.update!(is_correct: false)
                end
            end
        end
    end
end
