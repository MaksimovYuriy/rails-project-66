# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    linter = ApplicationContainer[:linter].new(check_id)
    linter.call
  end
end
