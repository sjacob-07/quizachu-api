class V1::UsersController < V1::BaseController
    before_action :get_current_user, except: [:update]
    

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
    def update
        auth_token = params[:gauth_id]
        email = params[:email]
        user = User.where(external_uid: auth_token).or(User.where(email: email)).first
        if user.present?
            #render json: {is_success: false, data: {}, message: 'User already exists with this Google Authentication Token or Email'}, status: 409
            render json: {is_success: true, data: user.rs, message: 'User Present'}, status: 200
        elsif auth_token && email && !(user.present?)
            user = User.create!({
                fullname: params[:fullname],
                email: email,
                external_uid: auth_token,
                profile_picture_url: params[:profile_picture_url],
            })
            role = RoleMaster.where(name: "Participant").first
            UserRole.create(user_id: user.id, role_master_id: role.id)
            
            render json: {is_success: true, data: user.rs, message: 'User successfully created'}, status: 200
        else
            if !(auth_token.present?)
                render json: {is_success: false, data: {}, message: 'Google Authentication Token not found'}, status: 422
            elsif !(email.present?)
                render json: {is_success: false, data: {}, message: 'User Email not found'}, status: 422
            end
        end
    end

    def dashboard
        uas = UserAssessment.where(user_id: @current_user.id)
        avg_score = uas.pluck(:percentage)/uas.count.to_f
        highest_score = uas.pluck(:percentage).sort.reverse[0]
        data = {
            user_id: @current_user.id, 
            assessment_count: uas.count,
            avg_score: avg_score.present? ? avg_score : nil ,
            highest_score: highest_score.present? ?highest_score : nil ,
            history: uas.map(&short_rs)
        }
        render json: {is_success: true, data: data, message: ''}, status: 200

    end


    
end
