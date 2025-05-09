# frozen_string_literal: true

module Web
  module Repository
    class CheckPolicy < ApplicationPolicy
      def show?
        record.repository.user_id == user.id
      end
    end
  end
end
