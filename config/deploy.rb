# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'nse_data'
set :repo_url, 'git@github.com:KelvinMutuma/nse_data.git'

set :deploy_user, 'deploy'
set :use_sudo, false

#forward authentication from local machine thro'
#when deployment server tries connectin to 
#git server..
#preferred to putting private key on deployment server

 set :ssh_options, {:forward_agent => true, :keys => %w(/home/kelvin/.ssh/id_rsa)}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/nse_data'

# Default value for :scm is :git
 set :scm, :git
 set :scm_passphrase, ""

# Default value for :format is :pretty
 set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false..to avoid capistrano asking for the passphrase
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
 set :keep_releases, 5

#what specs should be run b4 deployment is allowed to
#cintinue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

#which config files should be copied by deploy:setup_config
#see documentation in lib/capistrano/tasts/setup_config.cap
#for details of operation
set(:config_files, %w(
  nginx.config
  database.example.yml
  ))

#files which need to be symlinked to other parts of the
#filesystem. For example nginx virtualhosts, log rotation
#init scripts etc.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  }
  ])
  

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  #only allow a deploy with passing tests to be deployed
  before :deploy, "deploy:run_tests"
  #remove the default nginx configuration as it will tend
  #conflict with our configs
  before 'deploy:setup_config', 'nginx:remove_default_vhost' 

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  #compile assests locally then rysync
  after 'deploy:smylink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  #reload nginx to it will pick up any modified  vhosts from
  #setup_config
  after 'deploy:setup_config', 'nginx:reload'
  #restart monit so it will pick up any monit configs
  #we've added
  # after 'deploy:setup_config', 'monit:restart'
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
