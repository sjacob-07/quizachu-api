class V1::AssessmentsController < V1::BaseController
    before_action :get_current_user

    def index
        as = Assessment.where(is_active: true, status: "PUBLISHED")
        data = as.map(&:long_rs)
        render json: {is_success: true, data: data, message: ''}, status: 200
    end

    def show
        a_id =  params.has_key?(:assessment_id) ? params[:assessment_id].to_i  : nil
        if !a_id.present?
            render json: {is_success: false, data: {}, message: 'Assessment not found! Please check assessment ID'}, status: 409
        end
        assessment = Assessment.where(id: a_id, status: "PUBLISHED").first
        if assessment.present?
            data = assessment.rs
            render json: {is_success: true, data: data, message: ''}, status: 200
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
                passmark: passmark.present? ? passmark : rand(75..100),
                status: "DRAFT",
                ques_count: ques_count.present? ? ques_count : rand(1..10),
                is_active: true,
                category: category,
                created_by_id: @current_user.id,
            )
            render json: {is_success: true, data: assessment.short_rs, message: 'Assessment Created Successfully'}, status: 200
        end
    end
    

end
