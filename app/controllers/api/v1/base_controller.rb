class Api::V1::BaseController < ActionController::API
	rescue_from StandardError,                with: :internal_server_error
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	#helper :all
	private

	def not_found(exception, message="")
		if message == ""
			message = exception.message
		end
		render json: {status: 0, data: {}, message: message}, status: :not_found
	end

	def internal_server_error(exception, message="")
		if message == ""
			message = exception.message
		end
		if Rails.env.development?
			response = {status: 0, data: {}, message: message} #{ type: exception.class.to_s, message: exception.message, backtrace: exception.backtrace }
		else
			response = {status: 0, data: {}, message: message}
		end
		render json: response, status: :internal_server_error
	end

    def get_current_user
        auth_token = params[:gauth_id]
        @current_user = User.where(external_uid: auth_token).first
        if @current_user.present?
            return @current_user
        end

    end
end