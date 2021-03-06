require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Grasp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.browserify_rails.paths << /vendor\/assets\/javascripts/
    config.browserify_rails.commandline_options = %q{-t envify -t coffee-reactify --extension=".cjsx"}
    config.browserify_rails.source_map_environments << "development"

    config.autoload_paths += %W(#{config.root}/lib/modules)

    config.active_record.raise_in_transactional_callbacks = true

    # Use sidekiq for active job
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.default_url_options = { host: Rails.application.secrets.mailer['host'] }
  end
end
