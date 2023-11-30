class Api::V1::UsersController < Api::V1::BaseController
    before_action :get_current_user, except: [:create]
    

    ################# API DOCUMENTATION BEGIN #############
    # def_param_group :create_user do
    #     param :gauth_id, String, desc: 'Unique Identifier from the Google OAuth for the user', required: true
    #     param :email, String, desc: 'Unique Email of the created user',required: true
    #     param :fullname, String, desc: 'Fullname or the user name of the required user',required: true
    #     param :profile_picture_url, String, desc: 'URL of the profile picture'
    # end




    ################# METHODS BEGIN #############
    # api :POST, '/users', "Create a User"
    # param_group :create_user
    # returns :code => 200, :desc => "User successfully created" do
    #     param_group :create_user
    # end
    # returns :code => 409, :desc => "User already exists with this Google Authentication Token or Email"
    # returns :code => 422, :desc => "Google Authentication Token not found"
    def create
        auth_token = params[:gauth_id]
        email = params[:email]
        user = User.where(external_uid: auth_token).or(User.where(email: email))
        if user.present?
            render json: {is_success: false, data: {}, message: 'User already exists with this Google Authentication Token or Email'}, status: 409
        end

        if auth_token && email && !(user.present?)
            user = User.create!({
                fullname: params[:fullname],
                email: email,
                external_uid: auth_token,
                profile_picture_url: params[:profile_picture_url],
            })
            render json: {is_success: true, data: user.rs, message: 'User successfully created'}, status: 200
        else
            if !(auth_token.present?)
                render json: {is_success: false, data: {}, message: 'Google Authentication Token not found'}, status: 422
            elsif !(email.present?)
                render json: {is_success: false, data: {}, message: 'User Email not found'}, status: 422
            end
        end
    end


    
end
