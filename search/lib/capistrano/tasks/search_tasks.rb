namespace :search do
  task :load_initial do
    desc 'Load initial data to search'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "search:load_initial"
        end
      end
    end
  end
end
