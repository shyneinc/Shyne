source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '4.0.1'
gem 'pg'
gem 'thin'

group :production do
  gem 'rails_12factor'
  gem 'workless', '1.2.2'
end

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
#gem 'newrelic_rpm'

gem 'jquery-rails', '~> 3.0'
gem 'bootstrap-sass-rails'
gem 'angularstrap-rails', '~> 0.7.6'
gem 'just-datetime-picker'
#gem 'geokit' - I this we can use this for getting default timezone
#gem 'timezone' - For all timezone stuff

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
  gem 'factory_girl_rails', '4.2.1'
  gem 'rspec_api_documentation'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'heroku_san'
  gem 'guard-spork'
  gem 'guard-rspec'
  # gem 'guard-livereload'
end

group :test do
  gem 'faker', '~> 1.2.0'
  gem 'rack-test'
  gem 'turn', :require => false
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers', '>=0.3.0'
  gem 'spork-rails'
  gem 'json_spec'
  gem 'twilio-test-toolkit'
end
