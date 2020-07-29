set :stage, :communities
set(:branch, ENV['branch'] || 'master')

# This is used in the Nginx VirtualHost to specify which domains
# the app should appear on. If you don't yet have DNS setup, you'll
# need to create entries in your local Hosts file for testing.
set :server_name, "communities.pointsrocket.com"
set :secondary_http_server_names, "*.communities.pointsrocket.com"
# so coloque isso aqui caso queira que algum dominio rode na aplicação por http
# e esteja setado o enable_ssl true
set :secondary_only_http_server_names, ["comunidade.wine.com.br", "biolike.bioritmo.com.br", "advocacy.buzzmonitor.com.br"]

set :sidekiq_args, "-q default -c 5"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# server '78.47.66.184', port: 22, user: 'deploy', roles: %w{web app db}, primary: true
server 'production.pointsrocket.com', port: 2222, user: 'deploy', roles: %w{web app db}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 3

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, true

# secret repo url, used in secret.cap
set(:secret_repo_url, 'git@bitbucket.org:onrocket/secret.git')

set :linked_files, %w{config/application.yml config/apn.pem}

# secret repo files to be copied to config
set(:secret_copy_files, [
  {
    source: 'application.yml',
    dest: 'application.yml',
  },
  {
    source: 'apn.pem',
    dest: 'apn.pem',
  }
])

set :is_rappido, true
