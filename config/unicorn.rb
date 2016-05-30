worker_processes 2
timeout 30
preload_app true

listen '/home/valucon/apps/taskm/production/shared/tmp/sockets/unicorn.sock', backlog: 64

working_directory '/home/valucon/apps/taskm/production/current'

pid '/home/valucon/apps/taskm/production/shared/tmp/pids/unicorn.pid'

stderr_path '/home/valucon/apps/taskm/production/shared/log/unicorn.log'
stdout_path '/home/valucon/apps/taskm/production/shared/log/unicorn.log'

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = '/home/valucon/apps/taskm/production/current/Gemfile'
end

before_fork do |server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH # rubocop:disable Lint/HandleExceptions
    end
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
