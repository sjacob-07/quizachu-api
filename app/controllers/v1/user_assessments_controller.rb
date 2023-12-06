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
                    is_correct: nil
                )
            end
        end
        ua.update(attempts_taken: ua .attempts_taken + 1)
        ua.update(completed_on: DateTime.now)


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
