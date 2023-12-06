require "uri"
require "json"
require "net/http"

class V1::AssessmentsController < V1::BaseController
    before_action :get_current_user

    def index
        as = Assessment.where(is_active: true, status: "PUBLISHED")
        data = Hash.new
        data[:current_user_role]  = @current_user.user_role&.role_master&.name
        data[:assessments] = as.map(&:long_rs)
        render json: {is_success: true, data: data, message: ''}, status: 200
    end

    def show
        a_id =  params.has_key?(:assessment_id) ? params[:assessment_id].to_i  : nil
        if !a_id.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID not present.'}, status: 409
        end
        assessment = Assessment.where(id: a_id, status: "PUBLISHED", is_active: true).first
        if assessment.present?
            data = assessment.rs
            render json: {is_success: true, data: data, message: ''}, status: 200
        else
            render json: {is_success: false, data: {}, message: 'Assessment not found! Please check assessment ID'}, status: 409
        end
    end

    def create
        title =  params.has_key?("title") ? params["title"]  : nil
        description =  params.has_key?("description") ? params["description"]  : nil
        category =  params.has_key?("category") ? params["category"]  : nil
        duration =  params.has_key?("duration") ? params["duration"]  : nil
        image_url =  params.has_key?("image_url") ? params["image_url"]  : nil
        context =  params.has_key?("context") ? params["context"]  : nil
        passmark =  params.has_key?("passmark") ? params["passmark"].to_i  : nil
        ques_count =  params.has_key?("ques_count") ? params["ques_count"]  : nil

        if !title.present? || !context.present?
            render json: {is_success: false, data: {}, message: 'Assessment Title or Context not found'}, status: 409
        end

        if title.present? && context.present?
            assessment = Assessment.create(
                title: title,
                description: description.present? ? description : "",
                image_url: image_url,
                passmark: rand(65..100),
                status: "DRAFT",
                is_active: true,
                category: category,
                created_by_id: @current_user.id,
                context: context
            )

            url = URI("https://quizachu-backend-h67ch72r3q-ew.a.run.app/generate-questions-and-answers")
            #url = URI(ENV["base_url"] + "generate-questions-and-answers")
            https = Net::HTTP.new(url.host, url.port)
            https.use_ssl = true
            # Set the read timeout (in seconds)
            https.read_timeout = 180  # for example, setting a 2-minute timeout

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/json"
            request.body = JSON.dump({
            "context": assessment.context})

            response = https.request(request)
            res = JSON.parse(response.body)

            res["questions"].each do |k,v|
                aq = AssessmentQuestion.create(
                    assessment_id: assessment.id,
                    question: v,
                    question_type: "SHORT_ANSWER",
                    question_description: "",
                    order_seq: k.to_i + 1,
                    confidence_score: res["confidence_score"][k]
                )
        
                if aq.present?
                    AssessmentOption.create(
                        assessment_id: assessment.id,
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
            ques_count = AssessmentQuestion.where(assessment_id: assessment.id).count
            assessment.update(ques_count: ques_count, status: "PUBLISHED")

            render json: {is_success: true, data: assessment.short_rs, message: 'Assessment Created Successfully'}, status: 200
        end
    end

    def details
        a_id =  params.has_key?(:assessment_id) ? params[:assessment_id].to_i  : nil
        if !a_id.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID not present.'}, status: 409
        end
        assessment = Assessment.where(id: a_id, status: "PUBLISHED", is_active: true).first
        if assessment.present?
            data = assessment.preview_rs
            render json: {is_success: true, data: data, message: ''}, status: 200
        else
            render json: {is_success: false, data: {}, message: 'Assessment not found! Please check assessment ID'}, status: 409
        end

    end

    def publish
        a_id =  params.has_key?(:assessment_id) ? params[:assessment_id].to_i  : nil
        data = params.has_key?(:data) ? params[:data] : nil
        
        if !a_id.present? || !data.present?
            render json: {is_success: false, data: {}, message: 'Assessment ID or Data not present.'}, status: 409
        end
        assessment = Assessment.where(id: a_id, status: "PUBLISHED", is_active: true).first
        if assessment.present?
            ques_ids = []
            data.each do |d|
                ques_id = d["question_id"]
                aq = AssessmentQuestion.where(id: ques_id).first
                if aq.present? && d["question"].present?
                    ques_ids << ques_id
                    aq.update(question: d["question"])
                    op = aq.options.first
                    if op.present? && d["answer"]
                        op.update(option: d["answer"])
                    end
                end
            end

            if ques_ids.count != AssessmentQuestion.where(assessment_id: assessment.id).count
                assessment.update(ques_count: ques_ids.count)
                d_qids = AssessmentQuestion.where(assessment_id: assessment.id).where.not(id: ques_ids).pluck(:id)
                UserAssessmentResponse.where(assessment_question_id: d_qids).update_all(deleted_at: DateTime.now)
                AssessmentOption.where(assessment_question_id: d_qids).update_all(deleted_at: DateTime.now)
                AssessmentQuestion.where(id: d_qids).update_all(deleted_at: DateTime.now)
            end

            render json: {is_success: true, data: assessment.preview_rs, message: ''}, status: 200
        else
            render json: {is_success: false, data: {}, message: 'Assessment not found! Please check assessment ID'}, status: 409
        end
    end
    

end
