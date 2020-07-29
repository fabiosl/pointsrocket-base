task :env do
  on roles(:app) do |server|
    server_index = ARGV[2].to_i

    return if server != roles(:app)[server_index]

    puts "Opening a console on: #{host}...."

    cmd = "ssh #{server.user}@#{host} -t 'vim #{fetch(:deploy_to)}/shared/config/application.yml'"

    exec cmd
  end
end
