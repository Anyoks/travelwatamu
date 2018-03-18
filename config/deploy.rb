# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "travelWatamu"
set :repo_url, "git@bitbucket.org:dennOrina/travelwatamu.git"

set :passenger_restart_with_touch, true

set :pty, true
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:keys] = ["/home/vagrant/.ssh/id_rsa"]

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/travelWatamu"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
# 
set :bundle_binstubs, nil
set :linked_files, %w{config/database.yml config/secrets.yml config/initializers/devise.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# cap production deploy:upload_yml
namespace :deploy do
    desc 'Upload YAML files.'
    task :upload_yml do
      on roles(:app) do
        execute "mkdir #{shared_path}/config -p"
        upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
        upload! StringIO.new(File.read("config/secrets.yml")), "#{shared_path}/config/secrets.yml"
        # upload! StringIO.new(File.read("config/initializers/devise.rb}")), "#{shared_path}/config/initializers/devise.rb"
      end
    end
end



# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end