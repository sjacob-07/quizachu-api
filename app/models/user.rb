class User < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    has_one :user_role
    
    def rs
        {
            user_id: id,
            fullname: fullname,
            email: email,
            external_uid: external_uid,
            profile_picture_url: profile_picture_url,
            user_role: self.user_role&.role_master&.name
        }  
    end
end
