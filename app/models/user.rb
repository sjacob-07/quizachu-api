class User < ApplicationRecord
    default_scope { where(deleted_at: nil) }
    
    def rs
        {
            fullname: fullname,
            email: email,
            external_uid: external_uid,
            profile_picture_url: profile_picture_url,
        }  
    end
end
