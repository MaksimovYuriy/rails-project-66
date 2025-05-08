# frozen_string_literal: true

namespace :lint do
  desc 'Run slim-lint'
  task slim: :environment do
    Rails.logger.debug 'Running slim-lint...'
    sh('bundle exec slim-lint app/views/**/*.slim')
  end

  desc 'Run rubocop-rails'
  task rubocop: :environment do
    Rails.logger.debug 'Running rubocop-rails...'
    sh('bundle exec rubocop --plugin rubocop-rails')
  end

  desc 'Run (slim && rubocop) lints'
  task all: %i[rubocop slim]
end
