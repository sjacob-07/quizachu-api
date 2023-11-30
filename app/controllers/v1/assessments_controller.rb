class V1::AssessmentsController < V1::BaseController
    before_action :get_current_user

    def index
        as = Assessment.where(is_active: true, status: "PUBLISHED")
        data = as.map(&:short_rs)
        render json: {is_success: true, data: data, message: ''}, status: 200
    end
    

end
