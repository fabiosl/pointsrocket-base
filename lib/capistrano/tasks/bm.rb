namespace :bm do
  task :seed do
    desc 'Create Bm courses'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "bm:seed"
        end
      end
    end
  end
end
