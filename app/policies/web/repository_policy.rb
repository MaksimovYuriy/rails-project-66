# frozen_string_literal: true

module Web
  class RepositoryPolicy < ApplicationPolicy
    def show?
      record.user_id == user.id
    end
  end
end
