set :deploy_to, "/home/valucon/apps/#{fetch(:application)}/production"
set :rails_env, 'production'
set :branch, 'master'
set :environment, 'production'
set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"
