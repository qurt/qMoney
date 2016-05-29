# config valid only for Capistrano 3.1

set :application, 'qmoney'
set :repo_url, 'git@github.com:qurt/qMoney.git'
application = 'qmoney'
set :rvm_type, :user
set :rvm_ruby_version, '2.2.0'
set :deploy_to, '/srv/www/rails/qmoney'
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :foreman do
  desc 'Start server'
  task :start do
    on roles(:all) do
      sudo "start #{application}"
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:all) do
      sudo "stop #{application}"
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:all) do
      sudo "restart #{application}"
    end
  end

  desc 'Server status'
  task :status do
    on roles(:all) do
      execute "initctl list | grep #{application}"
    end
  end
end

namespace :deploy do

  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir #{shared_path}/config/"
      execute "mkdir /srv/www/rails/#{application}/run/"
      execute "mkdir /srv/www/rails/#{application}/log/"
      execute "mkdir /srv/www/rails/#{application}/socket/"
      execute "mkdir #{shared_path}/system"
      sudo "ln -s /var/log/upstart /srv/www/log"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")

      upload!('shared/Procfile', "#{shared_path}/Procfile")

      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      sudo 'service nginx stop'
      sudo 'mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf_b'
      sudo "ln -s #{shared_path}/nginx.conf /etc/nginx/nginx.conf"
      sudo 'service nginx start'

=begin
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:setup'
        end
      end
=end
    end
  end

  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      execute "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -s #{shared_path}/Procfile #{release_path}/Procfile"
    end
  end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = "/srv/www/tmp/foreman"
      execute  "mkdir -p #{foreman_temp}"
      # Создаем папку current для того, чтобы foreman создавал upstart файлы с правильными путями
      execute "ln -s #{release_path} #{current_path}"

      within current_path do
        execute "cd #{current_path}"
        execute :bundle, "exec foreman export upstart #{foreman_temp} -a #{application} -u deployer -l /srv/www/rails/#{application}/log -d #{current_path}"
      end
      sudo "mv #{foreman_temp}/* /etc/init/"
      sudo "rm -r #{foreman_temp}"
    end
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "restart #{application}"
    end
  end

  after :finishing, 'deploy:cleanup'
  # after :finishing, 'deploy:compile_assets'
  after :finishing, 'deploy:restart'

  after :updating, 'deploy:symlink'

  after :setup, 'deploy:foreman_init'

  after :foreman_init, 'foreman:start'

  before :foreman_init, 'rvm:hook'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'


=begin
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
=end

end
