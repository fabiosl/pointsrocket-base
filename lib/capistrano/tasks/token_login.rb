desc 'Generate token login'
task :token_login, [:email] => 'deploy:set_rails_env' do |tasks, args|
  on roles :app do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "token_login:generate[#{args.email}]"
      end
    end
  end
end
