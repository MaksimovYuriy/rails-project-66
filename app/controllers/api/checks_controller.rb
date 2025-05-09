# frozen_string_literal: true

module Api
  class ChecksController < Web::ApplicationController
    skip_before_action :verify_authenticity_token

    def create

      if request.format.json? || request.headers['X-GitHub-Event'].present?
        event = request.headers['X-GitHub-Event']
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

      RepositoryCheckJob.perform_later(repository)
      redirect_to repository_path(repository)
    end
  end
end
