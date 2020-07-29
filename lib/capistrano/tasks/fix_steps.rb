namespace :fix_steps do
  task :set_free_steps do
    desc 'Fix free steps'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_steps:set_free_steps"
        end
      end
    end
  end
end
