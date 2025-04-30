class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository)
    check = repository.checks.build()
    linter = ApplicationContainer[:linter].new(repository.clone_url, check)
    linter.call
  end
end
