namespace :es do
  task :migrate_v1_0_1 do
    desc 'Runs migration for v1.0.1'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "es:migrate_v1_0_1"
        end
      end
    end
  end
end
