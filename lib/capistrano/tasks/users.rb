namespace :users do
  task :replycate_over_all_tenants do
    desc 'Replicate users over all tenants'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "users:replycate_over_all_tenants"
        end
      end
    end
  end
end
