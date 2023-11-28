class UserRole < ApplicationRecord
    default_scope { where(deleted_at: nil) }

    belongs_to :user
    belongs_to :role_master
end
