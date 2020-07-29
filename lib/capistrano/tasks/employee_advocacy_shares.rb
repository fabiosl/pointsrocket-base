namespace :employee_advocacy_shares do
  task :index_post_json do
    desc 'index employee advocacy share post json'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "employee_advocacy_shares:index_post_json"
        end
      end
    end
  end
end
