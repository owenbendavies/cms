set :application, 'cms'
set :repo_url, 'git@github.com:obduk/cms.git'

set :deploy_to, '/var/www/cms'

set :linked_dirs, ['log', 'tmp/pids', 'tmp/sockets']

set :log_level, :info

set :rails_env, :production

set :rbenv_ruby, '2.1.5'
set :rbenv_type, :system

namespace :deploy do
  before 'updated', 'upload_config_files' do
    on roles(:all) do
      upload!(
        "config/deploy/#{fetch(:stage)}.secrets.yml",
        "#{release_path}/config/secrets.yml"
      )
    end
  end

  after :publishing, :restart do
    on roles(:app), in: :sequence, wait: 10 do
      pid_file = "#{shared_path}/tmp/pids/unicorn.pid"

      execute :kill, "-s USR2 `cat #{pid_file}`" if test "[ -f #{pid_file} ]"
    end
  end
end
