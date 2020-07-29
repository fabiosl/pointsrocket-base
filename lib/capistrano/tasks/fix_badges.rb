namespace :fix_badges do
  task :badge_type do
    desc 'Fix badge types'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "fix_badges:badge_type"
        end
      end
    end
  end
end
