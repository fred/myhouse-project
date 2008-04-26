#require 'mongrel_cluster/recipes'
"$: << File.dirname(FILE) + '/../lib'"

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "dietdoc"
#set :svn_user, ENV['svn_user'] || "ProjectRedDawn"
set :mongrel_port, "8001"
set :rails_env, :production
set :svn_user, ENV['svn_user'] || "fredthemaster"
set :svn_password, ENV['svn_password'] || "fredthemaster"
#svn co --username fredthemaster --password fredthemaster http://svn2.cvsdude.com/ProjectRedDawn/dietdoc/trunk/ dietdoc2
set :repository, "http://svn2.cvsdude.com/ProjectRedDawn/dietdoc/trunk/"
#set :svn_password, Proc.new { Capistrano::CLI.password_prompt('SVN Password: ') }
#set :repository, Proc.new { "--username #{svn_user} " + "--password #{svn_password} " + "http://svn2.cvsdude.com/ProjectRedDawn/dietdoc/trunk" }

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

# For now one machine is all three roles:
webserver1 = "ec2-67-202-14-121.z-1.compute-1.amazonaws.com"

role :web, webserver1
role :app, webserver1
role :db,  webserver1, :primary => true
#role :db,  "db02.example.com", "db03.example.com"

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :chmod755, %w(script)
set :deploy_to, "/var/www/dietdoc.com/"   # defaults to "/u/apps/#{application}"
set :user, "root"                # defaults to the currenttly logged in user
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway
#set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :use_sudo, false
set :mongrel_pid, "#{deploy_to}/#{shared_dir}/mongrel.pid"
set :mongrel_conf, "#{deploy_to}/#{shared_dir}/config/mongrel_cluster.yml"

# =============================================================================
# SSH OPTIONS
# =============================================================================
#ssh_options[:keys] = "/Users/fred/private/.ec2/brian/rsa-dd-keypair"
ssh_options[:keys] = "rsa-dd-keypair"

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)


# Tasks may take advantage of several different helper methods to interact
# with the remote server(s). These are:
#
# * run(command, options={}, &block): execute the given command on all servers
#   associated with the current task, in parallel. The block, if given, should
#   accept three parameters: the communication channel, a symbol identifying the
#   type of stream (:err or :out), and the data. The block is invoked for all
#   output from the command, allowing you to inspect output and act
#   accordingly.
# * sudo(command, options={}, &block): same as run, but it executes the command
#   via sudo.
# * delete(path, options={}): deletes the given file or directory from all
#   associated servers. If :recursive => true is given in the options, the
#   delete uses "rm -rf" instead of "rm -f".
# * put(buffer, path, options={}): creates or overwrites a file at "path" on
#   all associated servers, populating it with the contents of "buffer". You
#   can specify :mode as an integer value, which will be used to set the mode
#   on the file.
# * render(template, options={}) or render(options={}): renders the given
#   template and returns a string. Alternatively, if the :template key is given,
#   it will be treated as the contents of the template to render. Any other keys
#   are treated as local variables, which are made available to the (ERb)
#   template.


# ===================================================================
# DATABASE.YML for deploy:setup
# ===================================================================
namespace :config do
  desc "Create database.yml in shared/config  for initial setup" 
  task :database_yml do
    database_configuration = render :template => <<-EOF
  login: &login
    adapter: mysql
    # for Gentoo linux this is the sock file for mysql
    soket: /var/run/mysqld/mysqld.sock
    username: <%= mysql_user %>
    password: <%= mysql_password %>

  development:
    database: <%= "#{application}_development" %>
    <<: *login

  test:
    database: <%= "#{application}_test" %>
    <<: *login

  production:
    database: <%= "#{application}_production" %>
    <<: *login
  EOF

    run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
    put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml" 
  end
end

# Create memcached.yml
namespace :config do
  desc "Create memcached.yml in shared/config path" 
  task :prepare_memcached do
    memcached_config = ERB.new <<-EOF
defaults:
  # 2 days
  ttl: 172800
  readonly: false
  urlencode: false
  c_threshold: 10000
  compression: false
  debug: false
  namespace: app
  sessions: false
  session_servers: false
  fragments: false
  memory: 128
  servers: 127.0.0.1:11211
  benchmarking: true
  raise_errors: true
  fast_hash: true
  fastest_hash: true

development:
  sessions: false
  fragments: false
  servers: 127.0.0.1:11211

# turn off caching
test: 
  disabled: true

production:
  memory: 128
  benchmarking: false
  servers:
    - 127.0.0.1:11211

EOF
    put memcached_config.result, "#{shared_path}/config/memcached.yml"
  end
end



# ===================================================================
# DEPLOY
# ===================================================================
# Overwrite some of the deploy task, since we are using Mongrel.
namespace :deploy do
  
  # Fix the permissions of script folder, since "windows" will set it to 644 not 755
  # for compatibility with "windows users" :) hi Brian!
  # Create the symlink to the database.yml file to the shared folder
  desc "Set the proper permissions for directories and files on the script folder"
  task :after_symlink do
    run(chmod755.collect do |item|
      "chmod -R 755 #{current_path}/#{item}*"
    end.join(" && "))
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml" 
    run "ln -nfs #{shared_path}/index #{current_path}/index"
    run "ln -nfs #{shared_path}/config/ultrasphinx #{current_path}/config/ultrasphinx"
    # Memcached
    run "ln -nfs #{shared_path}/config/memcached.yml #{current_path}/config/memcached.yml"
  end
  
  # ===================================================================
  # DEPLOY MONGREL TASKS
  # ===================================================================
  # Custom Mongrel Tasks, since we won't be using FCGI
  namespace :mongrel do 
    set :mongrel_conf, "#{deploy_to}/#{shared_dir}/config/mongrel_cluster.yml"
    
    desc "Restart task for mongrel cluster."
    task :restart, :roles => :app, :except => { :no_release => true } do
      deploy.mongrel.stop
      run "sleep 3"
      deploy.mongrel.start
    end
    desc "Stop the mongrel cluster."
    task :stop, :roles => :app do
      # Returns true if PID file exists and is a regular file.
      #invoke_command "if [  -f #{mongrel_pid} ]; then mongrel_rails stop --pid #{mongrel_pid}; fi"
      invoke_command "mongrel_rails cluster::stop --config #{mongrel_conf}"
    end
    desc "Start the mongrel cluster."
    task :start, :roles => :app do
      #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
      #invoke_command "mongrel_rails start --pid #{mongrel_pid} --port #{mongrel_port} --chdir #{current_path} --environment #{rails_env} -d", :via => run_method
      invoke_command "mongrel_rails cluster::start --config #{mongrel_conf}", :via => run_method
    end
  end
  
  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.stop
    run "sleep 3"
    deploy.mongrel.start
  end

end

# ==========================
# Custom "svn update" only, 
# ==========================
desc "only update the current version"
task :update_only, :roles => :app do
  invoke_command "cd #{current_path} && svn update"
  deploy.mongrel.restart
end

# ===================================================================
# CUSTOM MONGREL TASKS
# ===================================================================

desc "Custom restart task for mongrel"
task :restart, :roles => :app, :except => { :no_release => true } do
  deploy.mongrel.stop
  deploy.mongrel.start
end

desc "Custom start task for mongrel"
task :start, :roles => :app do
  deploy.mongrel.start
end

desc "Custom stop task for mongrel"
task :stop, :roles => :app do
  deploy.mongrel.stop
end

# ================================
# COLD START OF SQL DUMP SCHEMA
# ===============================
desc "Load SQL file into the databse db/db.sql"
task :load_sql, :roles => :app do
  deploy
	run "cd #{current_path} && mysql -u #{user} dietdoc_#{rails_env} < db/db.sql"
end


# ==========================
# Sphinx Index Tasks
# ==========================
desc "Update Index"
task :sphinx_update_index, :roles => :app do
  invoke_command "RAILS_ENV=#{rails_env} cd #{current_path} && rake ultrasphinx:index"
end

desc "Stop Sphinx"
task :sphinx_daemon_stop, :roles => :app do
  invoke_command "RAILS_ENV=#{rails_env} cd #{current_path} && rake ultrasphinx:daemon:stop"
end

desc "Start Sphinx"
task :sphinx_daemon_start, :roles => :app do
  invoke_command "RAILS_ENV=#{rails_env} cd #{current_path} && rake ultrasphinx:daemon:start"
end

desc "Restart Sphinx"
task :sphinx_daemon_restart, :roles => :app do
  invoke_command "RAILS_ENV=#{rails_env} cd #{current_path} && rake ultrasphinx:daemon:restart"
end

#rake ultrasphinx:bootstrap          # Bootstrap a full Sphinx environment
#rake ultrasphinx:configure          # Rebuild the configuration file for this particular environment.
#rake ultrasphinx:daemon:restart     # Restart the search daemon
#rake ultrasphinx:daemon:start       # Start the search daemon
#rake ultrasphinx:daemon:status      # Check if the search daemon is running
#rake ultrasphinx:daemon:stop        # Stop the search daemon
#rake ultrasphinx:index              # Reindex the database and send an update signal to the search daemon.
