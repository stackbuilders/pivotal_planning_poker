set :stages, %w(staging production)
set :default_stage, 'production'
require 'capistrano/ext/multistage'

set :application, "PivotalPlanningPoker"

set :scm, :git

set(:deploy_to) { "/var/projects/#{application}/#{stage}" }
set(:shared_data_dir) { "#{deploy_to}/shared/data" }

set :use_sudo, false
set :local_project_path, "/Users/justin/Code/PivotalPlanningPoker"

set :repository, "git@github.com:jsl/pivotal_planning_poker.git"

set :keep_releases, 5
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache

# When we migrate, trace any errors
set :migrate_env, "--trace"

set :loglines, 200

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  after "deploy:update", "deploy:cleanup"
  after "deploy:update_code", :symlink_database_yml
  after "deploy:update_code", :install_gems

  desc "Restart the Passenger system."
  task :restart, :roles => :app do
    passenger.restart
  end
end

# Assumes that the correct database.yml has already been installed on the
# slices.
task :symlink_database_yml, :roles => :app do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
end

task :install_gems do
  run "cd #{release_path} && bundle install"
end