namespace :oauth2_info do
  task :insert_in_default do
    desc 'Pick from tenant to default tenant'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "oauth2_info:insert_in_default"
        end
      end
    end
  end
end
