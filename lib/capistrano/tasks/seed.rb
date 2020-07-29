namespace :db do
  desc "Load db/seeds.rb"
  task :seed do
    on roles(:app) do
      execute "cd #{current_path}; RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec rake db:seed"
    end
  end
end
