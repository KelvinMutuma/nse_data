lock '3.2.1'

set :application, 'nse_data'
set :repo_url, 'git@github.com:KelvinMutuma/nse_data.git'


set :use_sudo, false

set :ssh_options, {:forward_agent => true, :keys => %w(/home/kelvin/.ssh/id_rsa)}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/nse_data'


 set :scm, :git
 set :scm_passphrase, ""

 set :format, :pretty
 set :log_level, :debug

set :linked_files, %w{config/database.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

 set :keep_releases, 5

set :tests, []
set(:config_files, %w(
  nginx.config
  database.example.yml
  ))

set(:symlinks, [
  {
    source: "nginx.conf",
    link: "etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  }
  ])


namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  before 'deploy:setup_config', 'nginx:remove_default_vhost' 

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after 'deploy:smylink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  after 'deploy:setup_config', 'nginx:reload'
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