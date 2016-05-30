lock '3.5.0'

set :repo_url, 'git@github.com:okodo/taskm.git'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/application.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')
set :keep_releases, 5
set :log_level, :debug
set :pty, false
set :application, 'taskm'
set :stages, %w(production)
set :default_stage, 'production'
set :rvm_ruby_version, '2.3.0@taskm'

server '79.120.61.58', user: 'valucon', roles: %w(web app db)
