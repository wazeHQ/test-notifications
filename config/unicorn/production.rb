worker_processes 8
base_path = "/home/rails/rails_projects/test_notifications/production"
working_directory "#{base_path}/current"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 45

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "/var/run/unicorn/test_notifications.sock;", :backlog => 64

pid "#{base_path}/shared/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/var/log/nginx/unicorn.test_notifications.stderr.log"
stdout_path "/var/log/nginx/unicorn.test_notifications.stdout.log"

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
