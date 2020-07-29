desc 'Open a rails console `cap [staging] console [server_index default: 0]`'
task :console do
  on roles(:app) do |server|
    server_index = ARGV[2].to_i

    return if server != roles(:app)[server_index]

    puts "Opening a console on: #{host}...."

    if not server.user.nil?
      user_prefix = "#{server.user}@"
    else
      user_prefix = ""
    end

    cmd = "ssh #{user_prefix}#{host} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec rails console'"
    p "ssh #{user_prefix}#{host} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec rails console'"

    exec cmd
  end
end
