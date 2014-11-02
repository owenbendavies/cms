set :application, 'cms'
set :repo_url, 'git@github.com:obduk/cms.git'

set :deploy_to, '/var/www/cms'

set :linked_dirs, ['tmp/pids', 'tmp/sockets']

set :log_level, :info

set :keep_releases, 3

set :rbenv_ruby, '2.1.2'
set :rbenv_type, :system

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      pid_file = "#{shared_path}/tmp/pids/unicorn.pid"

      if test "[ -f #{pid_file} ]"
        execute :kill, "-s USR2 `cat #{pid_file}`"
      end
    end
  end

  after :publishing, :restart
end

namespace :config_files do
  desc 'SCP local config files'
  task :upload do
    on roles(:all) do
      upload! "config/deploy/#{fetch(:stage)}.secrets.yml", "#{release_path}/config/secrets.yml"
    end
  end

  after 'deploy:updated', 'config_files:upload'
end
