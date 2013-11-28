require 'bundler/capistrano'

set :application, "cms"

# Capistrano multi stage
set :stages, %w(production localhost)
require 'capistrano/ext/multistage'

# SSH options
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = ENV['CAP_SSH_PORT'].to_i

# Repo config
set :repository,  "git@github.com:obduk/#{application}.git"
set :branch, "master"
set :deploy_via, :remote_cache

# Server config
set :user, "www-data"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"

# Default folders
_cset :shared_children, shared_children << 'tmp/sockets'

# Unicorn deploy
namespace :deploy do
  task :restart, roles: :app, except: { no_release: true } do
    pid_file = "#{current_path}/tmp/pids/unicorn.pid"

    if File.exists? pid_file
      pid = File.read(pid_file).to_i

      run "kill -s USR2 #{pid}"
    end
  end

  task :copy_figaro_config do
    transfer :up, "config/application.yml", "#{release_path}/config/application.yml", :via => :scp
  end
end

before 'deploy:finalize_update', 'deploy:copy_figaro_config'

# Cleanup
after "deploy:restart", "deploy:cleanup"
