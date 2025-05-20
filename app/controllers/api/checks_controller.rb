# frozen_string_literal: true

module Api
  class ChecksController < Web::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      if request.headers['X-GitHub-Event'].present?
        event = request.headers['X-GitHub-Event']
        return head :ok if event == 'ping'
        return head :bad_request unless event == 'push'

        payload = JSON.parse(request.body.read)
        github_id = payload.dig('repository', 'id')
      else
        github_id = params.dig(:repository, :id)
      end

      repository = ::Repository.find_by(github_id: github_id)

      unless repository
        return head :not_found
      end

      check = repository.checks.create

      RepositoryCheckJob.perform_later(check.id)
      head :ok
    end
  end
end
