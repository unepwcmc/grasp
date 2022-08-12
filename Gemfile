source 'https://rubygems.org'

# Frameworks
gem 'rails', '4.2.6'
gem 'sinatra', :require => false
# The previous version of mimemagic was pulled on 20/03/21 
# and licensing changed to GPL2.
# Can be removed if paperclip is removed.
gem 'mimemagic', '~> 0.3.6'

# DB
#gem 'pg', '~> 0.18.4'
# Paperclip is the only reverse-dependency of mimemagic and is deprecated in 
# favour of ActiveStorage. It can be refactored out when upgrading to Rails 5.2.
# If this is removed, also remove mimemagic.
gem 'paperclip', '~> 5.1.0'

# Frontend
gem 'kaminari', '~> 0.17.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'browserify-rails', '~> 3.1.0'
gem 'font-awesome-sass', '~> 4.6.2'
gem 'jquery-rails', '~> 4.1.1'
gem "select2-rails", git: 'https://github.com/argerim/select2-rails'

# Configuration
gem 'dotenv-rails', '~> 2.1.1'

# Logging'n'tracking
gem 'appsignal', '~> 1.1.9'
gem 'exception_notification', '~> 4.1.4'
gem 'slack-notifier', '~> 1.5.1'

# Authentication and Authorization
gem 'cancancan', '~> 1.10'
gem 'devise', '~> 4.2.0'

# Background jobs
gem 'redis', '~> 3.3.1'
gem 'sidekiq', '~> 4.1.4'

# Testing
gem 'factory_girl_rails', '~> 4.7.0'
gem 'faker', '~> 1.6.5'

group :development do
  # Docs
  gem 'yard', '~> 0.8.7.6'
  gem 'redcarpet', '~> 3.3.4'

  # Deployment
  gem 'capistrano-rails'
  gem 'capistrano', '~> 3.5', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
  gem 'capistrano-passenger', '~> 0.2.0', require: false
  gem 'capistrano-npm', '~> 1.0.2'
  gem 'capistrano-sidekiq', require: false

  # Emails
  gem 'letter_opener'

  # ERD
  gem 'ruby-graphviz', '~> 1.2.2'
  gem 'rails-erd', '~> 1.4.7'
end

group :test do
  gem 'simplecov', require: false
  gem 'mocha', '~> 1.1.0'
  gem 'codeclimate-test-reporter', require: false
end

# Debugging
gem 'web-console', '~> 2.0', group: :development
gem 'byebug', group: [:development, :test]
gem 'annotate', '~> 2.7.1'

gem "activerecord-session_store", "~> 1.1"
