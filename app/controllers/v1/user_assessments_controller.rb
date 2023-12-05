class V1::UserAssessmentsController < V1::BaseController
    before_action :get_current_user


    def submit_answers
        a_id = params.has_key?(:assessment_id) ? params[:assessment_id]  : nil
        data = params.has_key?(:data) ? params[:data]  : nil
        if !a_id.present? || !data.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID or Answers JSON not found'}, status: 409
        end

        a = Assessment.where(id: a_id).first
        if !a.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID Invalid'}, status: 409
        end

        ua = UserAssessment.where(user_id: @current_user.id, assessment_id: a.id).first
        if !ua.present?
            ua = UserAssessment.create(
                user_id: @current_user.id,
                assessment_id: a.id,
                started_at: DateTime.now,
                attempts_taken: 0
            )
        end
        data.each do |d|
            q_id = d["question_id"]
            ques = AssessmentQuestion.where(id: q_id, assessment_id: a.id).first
            if ques.present?
                uar = UserAssessmentResponse.where(user_id: @current_user.id,
                    assessment_id: a.id,
                    assessment_question_id: ques.id).first
                
                if !uar.present?
                    uar = UserAssessmentResponse.create!(
                            user_id: @current_user.id,
                            assessment_id: a.id,
                            assessment_question_id: ques.id,
                            started_at: DateTime.now, 
                            user_assessment_id: ua.id  
                        )
                end

                #labels = ["contradiction", "entailment", "neutral"]

                uar.update(user_answer: d["user_answer"],
                    user_answer_url: d["user_answer_url"],
                    is_answered: true,
                    completed_on: DateTime.now,
                )

                gold_answer = uar&.assessment_question&.options&.first&.option

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
                        uar.update(
                            answer_evaluation_label: res["prediction"],
                            probability_score: res["probability"],
                            model_evaluated: true,
                            evaluated_at: DateTime.now
                        )

                        if uar.answer_evaluation_label == "entailment" && uar.probability_score.to_i >= 75
                            uar.update(
                                is_correct: true,
                            )
                        end
                    end
                end
            end
        end

        ques_count = a.ques_count
        correct_answers = UserAssessmentResponse.where(user_id: @current_user.id, assessment_id: a.id, is_correct: true)
        perct = ((correct_answers.count.to_f/ ques_count.to_f) * 100.0).round(2)

        if perct > ua.percentage.to_i
            ua.update!(marks_obtained: correct_answers.count, percentage: perct)
        end
        ua.update(attempts_taken: ua .attempts_taken + 1)

        if ua.percentage.to_i >= a.passmark.to_i && ua.is_passed != true
            ua.update(is_passed: true, completed_on: DateTime.now)
        elsif ua.is_passed == nil
            ua.update(is_passed: false, completed_on: DateTime.now)
        end

        render json: {is_success: true, data: ua.short_rs, message: 'Assessment Response successfully submitted'}, status: 200
    end

    def view_answers
        a_id = params.has_key?(:assessment_id) ? params[:assessment_id]  : nil
        if !a_id.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID not found'}, status: 409
        end

        ua = UserAssessment.where(user_id: @current_user.id, assessment_id: a_id).first
        if !ua.present?
            render json: {is_success: false, data: {}, message: 'User has not attempted this assessment'}, status: 409
        end

        data = ua.responses.map(&:result_rs)

        render json: {is_success: true, data: data, message: 'Successful'}, status: 200

    end

end
