class V1::AssessmentsController < V1::BaseController
    before_action :get_current_user

    def index
        as = Assessment.where(is_active: true, status: "PUBLISHED")
        data = as.map(&:short_rs)
        render json: {is_success: true, data: data, message: ''}, status: 200
    end

    def show
        a_id =  params.has_key?(:assessment_id)? params[:assessment_id].to_i  : nil
        if !a_id.present?
            render json: {is_success: false, data: {}, message: 'Assessment not found! Please check assessment ID'}, status: 409
        end
        assessment = Assessment.where(id: a_id, status: "PUBLISHED").first
        if assessment.present?
            data = assessment.rs
            render json: {is_success: true, data: data, message: ''}, status: 200
        end
    end
    

end
