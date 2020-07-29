namespace :paperclip do
  desc "Refresh paperclip styles."
  task :refresh_missing_styles do
    on roles(:app) do
      execute "cd #{current_path}; RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec rake paperclip:refresh:missing_styles"
    end
  end
end
