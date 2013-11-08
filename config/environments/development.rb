Shyne::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: "localhost:3000" }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  ENV['AWS_ACCESS_KEY'] = "AKIAJM7FCUEYPATUV54Q"
  ENV['AWS_SECRET_KEY'] = "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"
  ENV['AWS_BUCKET'] = "shynedev"

  ENV['TWILIO_SID'] = "AC4f20ae17644502d367b100f451b5b8e0"
  ENV['TWILIO_TOKEN'] = "ba9cd06f9049217ad193da230e2918af"
end
