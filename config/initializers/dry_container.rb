# frozen_string_literal: true

require 'dry-container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:octokit_client) { OctokitClientStub }
    register(:linter) { LinterServiceStub }
  else
    register(:octokit_client) { Octokit::Client }
    register(:linter) { LinterService }
  end
end
