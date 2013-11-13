# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Shyne::Application.load_tasks

# Don't try to dump structure.sql unless it's dev env
Rake::Task["db:structure:dump"].clear unless Rails.env.development?
