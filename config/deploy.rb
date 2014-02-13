set :application, 'cms'
set :repo_url, 'git@github.com:obduk/cms.git'

set :deploy_to, '/var/www/cms'

set :linked_dirs, ['tmp/pids', 'tmp/sockets']

set :log_level, :info

set :keep_releases, 3

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      pid_file = "#{shared_path}/tmp/pids/unicorn.pid"

      if test "[ -f #{pid_file} ]"
        execute :kill, "-s USR2 `cat #{pid_file}`"
      end
    end
  end

  after :publishing, :restart
end

namespace :figaro do
  desc 'SCP transfer figaro configuration'
  task :upload_config do
    on roles(:all) do
      upload! "config/deploy/#{fetch(:stage)}.application.yml", "#{release_path}/config/application.yml"
    end
  end

  after 'deploy:updated', 'figaro:upload_config'
end
