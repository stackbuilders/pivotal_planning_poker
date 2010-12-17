# Production-specific deployment rules.
set :application_url, "zizek"
set :rails_env, "production"

set :user, 'justin'

role :app, application_url
role :web, application_url
role :db,  application_url, :primary => true