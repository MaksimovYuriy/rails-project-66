module Web
    class RepositoriesController < Web::ApplicationController
        before_action :authenticate_user!

        def index

        end

        def new
            @github_repositories = github_client.repos.select { |repo| repo&.language == 'Ruby'}
            @repository = Repository.new
        end

        private

        def github_client
            client = Octokit::Client.new(
                access_token: current_user.token,
                auto_paginate: true
            )
        end

    end
end
