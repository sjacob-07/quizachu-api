class User < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    def rs
        {
            user_id: id,
            fullname: fullname,
            email: email,
            external_uid: external_uid,
            profile_picture_url: profile_picture_url,
        }  
    end
end
