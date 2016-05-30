namespace :db do
  desc 'seed database'
  task :seed do
    on roles(:app), except: { no_release: true } do
      within current_path do
        with rails_env: fetch(:environment) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
