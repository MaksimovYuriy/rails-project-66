# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
           ENV.fetch('GH_CLIENT_ID'),
           ENV.fetch('GH_CLIENT_SECRET'),
           scope: 'user,public_repo,admin:repo_hook'
end
