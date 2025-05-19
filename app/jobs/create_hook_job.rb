class CreateHookJob < ApplicationJob
    queue_as :default

    def perform(repo_full_name, user_token)
        existing_hooks = github_client(user_token).hooks(repo_full_name)
        hook_exists = existing_hooks.any? do |hook|
            hook.config['url'] == "#{ENV.fetch('BASE_URL', nil)}/api/checks"
        end

        return if hook_exists

        github_client(user_token).create_hook(
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

    def github_client(user_token)
        ApplicationContainer[:octokit_client].new(
            access_token: user_token,
            auto_paginate: true
        )
    end
end