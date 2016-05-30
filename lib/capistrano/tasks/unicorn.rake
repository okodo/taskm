after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'Start Application'
  task :start do
    on roles(:app), except: { no_release: true } do
      within current_path do
        if test("[ -e #{fetch(:unicorn_pid)} ] && kill -0 #{pid}")
          info ' unicorn is running...'
        else
          execute :bundle, 'exec unicorn_rails', '-c', fetch(:unicorn_conf), '-E', fetch(:environment), '-D'
        end
      end
    end
  end

  desc 'Stop Application'
  task :stop do
    on roles(:app), except: { no_release: true } do
      within current_path do
        if test("[ -e #{fetch(:unicorn_pid)} ]")
          if test("kill -0 #{pid}")
            info ' stopping unicorn...'
            execute :kill, '-s QUIT', pid
          else
            info ' cleaning up dead unicorn pid...'
            execute :rm, fetch(:unicorn_pid)
          end
        else
          info ' unicorn is not running...'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    invoke 'deploy:start'
    on roles(:app), except: { no_release: true } do
      within current_path do
        info ' unicorn restarting...'
        execute :kill, '-s USR2', pid
      end
    end
  end
end

def pid
  "`cat #{fetch(:unicorn_pid)}`"
end
