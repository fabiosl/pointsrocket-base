Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDIS_HOST"],
    password: ENV["REDIS_PASSWORD"]
  }
end

def configure_cron
  schedule_file = "config/schedule.yml"

  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

def configure_server
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV["REDIS_HOST"],
      password: ENV["REDIS_PASSWORD"]
    }

    configure_cron
  end
end

configure_server
# if Rails.env == 'production'
#   # For production, run server configs
# else
#   # For local, just start up the cron service
#   configure_cron
# end
