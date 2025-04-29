# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://d5c201a0e5f04a9f56446b27e717864e@o4508844991053824.ingest.de.sentry.io/4509209760235600'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end
