set :application, 'onrocket'
set :deploy_user, 'deploy'
set :use_sudo, true
# set :stages, %w(production staging cbfa)

# setup repo details
# set :scm, :git
set :repo_url, 'git@bitbucket.org:onrocket/on_rocket_app.git'

set :bundle_flags, "--deployment"

# setup rvm.
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, fetch(:rbenv_map_bins).to_a.concat(%w{rake gem bundle ruby rails}).uniq

# how many old releases do we want to keep, not much
set :keep_releases, 5

# files we want symlinking to specific entries in shared
set :linked_files, %w{config/application.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :slack_webhook, "https://hooks.slack.com/services/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"

set :sidekiq_options_per_process, ["--queue teste"]
set :pty, false

# if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# if you want to exclude table from dump
set :db_ignore_tables, []

# if you want to exclude table data (but not table schema) from dump
set :db_ignore_data_tables, []

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/system public/uploads)
set :local_assets_dir, "public"

# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
set :locals_rails_env, "development"

# if you are highly paranoid and want to prevent any push operation to the server
# set :disallow_pushing, true

# if you prefer bzip2/unbzip2 instead of gzip
# set :compressor, :bzip2


# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
#set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.example.yml
  secrets.sample.yml
  log_rotation
  unicorn.rb
  unicorn_init.sh
  sidekiq_init.sh
  monit
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
  sidekiq_init.sh
))


# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "unicorn_init.sh",
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: "sidekiq_init.sh",
    link: "/etc/init.d/sidekiq_{{full_app_name}}"
  },
  {
    source: "log_rotation",
    link: "/etc/logrotate.d/{{full_app_name}}"
  },
  {
    source: "monit",
    link: "/etc/monit/conf.d/onrocket_{{full_app_name}}"
  }
])

set :slackistrano, {
  channel: '#deploy',
  webhook: 'https://hooks.slack.com/services/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'
}

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
  # # make sure we're deploying what we think we're deploying
  # before :deploy, "deploy:check_revision"

  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # get secret env after setup config
  after 'deploy:setup_config', 'secret:get_secret_envs'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # paperclip, refresh styles
  # after 'deploy:restart', 'paperclip:refresh_missing_styles'
  # Restart monit so it will pick up any monit configurations
  # we've added
  #after 'deploy:setup_config', 'monit:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  # after 'deploy:publishing', 'deploy:restart'
  after 'deploy:publishing', 'monit:restart'
  after 'deploy:publishing', 'monit:restart_jobs'
end

