class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    has_many :questions, :class_name => 'AssessmentQuestion', :foreign_key => 'assessment_id'

    def rs
        data = self.short_rs
        data[:questions] = self.questions.where(question_type: ["SHORT_ANSWER", "LONG_ANSWER"]).order(:order_seq).map(&:rs)
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
            created_by_id: User.where(id: created_by_id).first&.rs,
            created_at: created_at.strftime("%d/%m/%Y %H:%M"),
        }
    end
    
    
    def long_rs
        data = self.short_rs
        data.merge!(leaderboard_data)

        return data
    end

    def preview_rs
        data = self.short_rs
        data["questions"] = self.questions.where(question_type: ["SHORT_ANSWER", "LONG_ANSWER"]).order(:order_seq).map(&:preview_rs)
        data["context"] = context
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

    def generate_questions
        #API
        url = URI("https://quizachu-backend-h67ch72r3q-ew.a.run.app/generate-questions-and-answers")
        #url = URI(ENV["base_url"] + "generate-questions-and-answers")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        # Set the read timeout (in seconds)
        https.read_timeout = 600  # for example, setting a 2-minute timeout

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
        request.body = JSON.dump({
        "context": self.context})

        #RESPONSE
        response = https.request(request)
        if response.code.to_i == 200
            res = JSON.parse(response.body)

            res["questions"].each do |k,v|
                aq = AssessmentQuestion.create(
                    assessment_id: self.id,
                    question: v,
                    question_type: "SHORT_ANSWER",
                    question_description: "",
                    order_seq: k.to_i + 1,
                    confidence_score: res["confidence_score"][k]
                )
        
                if aq.present?
                    AssessmentOption.create(
                        assessment_id: self.id,
                        assessment_question_id: aq.id,
                        option: res["answers"][k],
                        order_seq: 1,
                        is_correct_option: true,
                        option_type: "TEXT",
                        model_generated: true,
                        generated_at: DateTime.now
                    )
                end
            end
            ques_count = AssessmentQuestion.where(assessment_id: self.id).count
            self.update(ques_count: ques_count, status: "PUBLISHED")
        end
    end

    def delete_assessment
        UserAssessmentResponse.where(assessment_id: self.id).update_all(deleted_at: DateTime.now)
        UserAssessment.where(assessment_id: self.id).update_all(deleted_at: DateTime.now)
        AssessmentQuestion.where(assessment_id: self.id).update_all(deleted_at: DateTime.now)
        self.update(deleted_at: DateTime.now)
    end
end
