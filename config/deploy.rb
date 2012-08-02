task :kill_old_master, :roles => :app, :except => {:no_release => true} do
  logger.important("Stopping old master...", "Unicorn")
  old_pid = "#{fetch(:current_path)}/tmp/pids/unicorn.pid.oldbin"
  run "#{try_sudo} kill -s QUIT `cat #{old_pid}`"
end

after 'unicorn:reload', :kill_old_master

set :rvm_ruby_string, 'ruby-1.9.3-p0@rails_3_1_1'

def location location_name, server_name, rails_env=:production, url_root="/", &block
  task location_name do
    block.call unless block.nil?
    default_environment['LOCATION'] = location_name.to_s
    server server_name, :app, :web
    require "bundler/capistrano"
    role :db, server_name, :primary => true

    # default_environment["RAILS_RELATIVE_URL_ROOT"] = url_root
    set :rails_env, rails_env
    set :unicorn_env, rails_env

#    set :deploy_to, "/home/linqmap/rails_projects/adman2#{url_root}"
    set :deploy_to, "~/rails_projects/test_notifications#{url_root}"

    if [:production].include? rails_env
      load 'deploy/assets'
    end

    require 'capistrano-unicorn'

  end
end

set :application, "test_notifications"

#set :user, 'linqmap'
set :user, 'rails'

# set :repository,  "bzr+ssh://bzruser@linq.linqmap/home/bzruser/web/advil/"
set :repository,  "."
set :use_sudo, false

#since our production servers don't have access to git, we deploy using 'git export'
set :scm, :git
set :deploy_via, :copy

# location :staging, '79.125.117.51', :production, "/staging"
location :staging, '54.247.120.115', :production, '/production'
# location :israel, '79.125.117.51', :production, "/production"
#location :il, '79.125.25.212', :production, '/production'
#location :world, '46.137.120.208', :production, '/production'
#location :us, '23.23.124.144', :production, '/production'
#location :staging, 'il-waze-web-new1.', :development, "/staging"
#location :israel_old, 'il-waze-web-new1.', :production, "/production"
#location :israel, 'il-waze-businesses1.', :production, "/production"
