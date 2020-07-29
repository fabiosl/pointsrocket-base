namespace :secret do
  desc "get secret envs from secret repository"

  task :get_secret_envs do
    on roles(:app) do
      clone_or_pull_secret = """
        cd #{shared_path}; if [ -d \"secret\" ]; then cd secret; git pull; else git clone #{fetch(:secret_repo_url)} secret; fi
      """
      execute clone_or_pull_secret

      fetch(:secret_copy_files, []).each do |copy_file|
        dest = "#{shared_path}/config/#{copy_file[:dest]}"
        execute "rm #{dest} ; ln -s #{shared_path}/secret/#{fetch(:stage)}/#{copy_file[:source]} #{dest}"
      end

    end
  end

end
