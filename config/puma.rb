threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
#port ENV.fetch("PORT") { 3001 }
environment ENV.fetch("RAILS_ENV") { "production" }

localhost_key = "#{File.join('config', 'local-certs', 'privkey.pem')}"
localhost_crt = "#{File.join('config', 'local-certs', 'fullchain.pem')}"

#ssl_bind '0.0.0.0', 3000, {
#    key: localhost_key,
#    cert: localhost_crt,
#    verify_mode: 'none'
#  }

workers 1
# Min and Max threads per worker
threads 1, 6
app_dir = '/home/ubuntu/apps/quizachu/quizachu-api'
shared_dir = "#{app_dir}/shared"
# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env
# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"
# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app


on_worker_boot do
require "active_record"
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end