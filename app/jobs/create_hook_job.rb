class CreateHookJob < ApplicationJob
    queue_as :default

    def perform(repo_full_name)
        xisting_hooks = github_client.hooks(repo_full_name)
        hook_exists = existing_hooks.any? do |hook|
            hook.config['url'] == "#{ENV.fetch('BASE_URL', nil)}/api/checks"
        end

        return if hook_exists

        github_client.create_hook(
            repo_full_name,
            'web',
            {
                url: "#{ENV.fetch('BASE_URL', nil)}/api/checks",
                content_type: 'json'
            },
            {
                events: ['push'],
            active: true
            }
        )
    end

    private

    def github_client
        ApplicationContainer[:octokit_client].new(
            access_token: current_user.token,
            auto_paginate: true
        )
    end
end