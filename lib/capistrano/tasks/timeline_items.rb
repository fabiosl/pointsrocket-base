namespace :timeline_items do
  task :index_all do
    desc 'Index all item to timeline'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "timeline_items:index_all"
        end
      end
    end
  end

  task :send_to_es do
    desc 'Send all to es'
    on roles :app do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "timeline_items:send_to_es"
        end
      end
    end
  end
end
