# This is a sample Capistrano config file for rubber

set :rails_env, RUBBER_ENV

on :load do
  set :application, rubber_env.app_name
  set :runner,      rubber_env.app_user
  set :deploy_to,   "/mnt/#{application}-#{RUBBER_ENV}"
  set :copy_exclude, [".git/*", ".bundle/*", "log/*", ".rvmrc"]
end

# Use a simple directory tree copy here to make demo easier.
# You probably want to use your own repository for a real app
set :scm, :git
set :repository, "git@urbaninteractive.unfuddle.com:urbaninteractive/escapist.git"
set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true }

# Easier to do system level config as root - probably should do it through
# sudo in the future.  We use ssh keys for access, so no passwd needed
set :user, 'root'
set :password, nil

# Use sudo with user rails for cap deploy:[stop|start|restart]
# This way exposed services (mongrel) aren't running as a privileged user
set :use_sudo, true

# How many old releases should be kept around when running "cleanup" task
set :keep_releases, 3

# Lets us work with staging instances without having to checkin config files
# (instance*.yml + rubber*.yml) for a deploy.  This gives us the
# convenience of not having to checkin files for staging, as well as 
# the safety of forcing it to be checked in for production.
set :push_instance_config, RUBBER_ENV != 'production'

# Allows the tasks defined to fail gracefully if there are no hosts for them.
# Comment out or use "required_task" for default cap behavior of a hard failure
rubber.allow_optional_tasks(self)
# Wrap tasks in the deploy namespace that have roles so that we can use FILTER
# with something like a deploy:cold which tries to run deploy:migrate but can't
# because we filtered out the :db role
namespace :deploy do
  rubber.allow_optional_tasks(self)
  tasks.values.each do |t|
    if t.options[:roles]
      task t.name, t.options, &t.body
    end
  end
end


after "deploy", "rubber:set_permissions"
after "deploy", "rubber:package_assets"
after "deploy:migrations", "rubber:package_assets"

namespace :rubber do
  desc "Set permissions"
  task :set_permissions, :roles => :app do
    run "cd #{current_path}; chown -R root public"
    run "cd #{current_path}/public; chown -R root assets"
    run "cd #{current_path}/public; chown -R root javascripts"
    run "cd #{current_path}/public; chown -R root stylesheets"
  end

  desc "Package deployment assets"
  task :package_assets, :roles => :app do
    
     run "cd #{deploy_to}/current && bundle exec jammit --base-url 'http://escapist.me'"
     
    #run "cd #{current_path}; RAILS_ENV=#{RUBBER_ENV} /usr/bin/env rake utils:package"
    # For Apache content negotiation with Multiviews, we need to rename .css files to .css.css and .js files to .js.js.
    # They will live alongside .css.gz and .js.gz files and the appropriate file will be served based on Accept-Encoding header.
    # run "cd #{current_release}/public/assets; for f in *.css; do mv $f `basename $f .css`.css.css; done; for f in *.js; do mv $f `basename $f .js`.js.js; done"
  end  
end


# load in the deploy scripts installed by vulcanize for each rubber module
Dir["#{File.dirname(__FILE__)}/rubber/deploy-*.rb"].each do |deploy_file|
  load deploy_file
end

after "deploy", "deploy:cleanup"

        require './config/boot'
        require 'hoptoad_notifier/capistrano'
