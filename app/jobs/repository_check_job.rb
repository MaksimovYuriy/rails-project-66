# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository)
    check = repository.checks.build
    linter = ApplicationContainer[:linter].new(repository.clone_url, check, repository.language, repository.full_name)
    linter.call
  end
end
