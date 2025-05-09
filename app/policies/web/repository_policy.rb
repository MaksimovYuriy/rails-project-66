module Web
    class RepositoryPolicy < ApplicationPolicy
        def show?
            record.user_id == user.id
        end
    end
end