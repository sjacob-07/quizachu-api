class Assessment < ApplicationRecord
    default_scope { where(deleted_at: nil) }
end
