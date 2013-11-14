source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.1'
gem 'pg'
gem 'thin'

group :production, :staging do
  gem 'rails_12factor'
end

gem 'workless', '1.2.2'

#scheduling job and queuing
gem 'delayed_job_active_record'
gem 'daemons'

gem 'nokogiri'
gem 'jbuilder', '~> 1.2'
gem 'devise', '3.1.0'
gem 'json'
gem 'pg_array_parser'
gem 'pg_search'
gem 'phony_rails'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'raddocs'
gem 'kaminari'

gem 'jquery-rails', '~> 3.0'
gem 'bootstrap-sass-rails'
gem 'angularstrap-rails', '~> 0.7.6'
gem 'just-datetime-picker'

gem 'carrierwave'
gem "fog", "~> 1.15.0"
gem 'unf'
gem 'rmagick', '2.13.2'

gem 'twilio-ruby'
gem 'classy_enum'

group :assets do
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails'
  gem 'sass'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'rspec_api_documentation'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'heroku_san'
  gem 'guard-spork'
  gem 'guard-rspec'
end

group :development, :staging, :test do
  gem 'factory_girl_rails', '4.2.1'
  gem 'faker', '~> 1.2.0'
  gem 'database_cleaner'
end

group :test do
  gem 'rack-test'
  gem 'turn', :require => false
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers', '>=0.3.0'
  gem 'spork-rails'
  gem 'json_spec'
  gem 'twilio-test-toolkit'
end
