SSHKit.config.command_map[:whenever] = 'bundle exec whenever'

set :application, 'cms'
set :repo_url, 'git@github.com:obduk/cms.git'

set :deploy_to, '/var/www/cms'

set :linked_dirs, fetch(:linked_dirs, []).push('tmp/pids', 'tmp/sockets')

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
      upload! 'config/application.yml', "#{release_path}/config/application.yml"
    end
  end

  after 'deploy:updated', 'figaro:upload_config'
end
