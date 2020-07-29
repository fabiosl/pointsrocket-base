Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_KEY']
  config.release_stage = ENV['BUGSNAG_RELEASE_STAGE'] || 'development'
  config.notify_release_stages = (ENV['BUGSNAG_NOTIFY_RELEASE_STAGES'] || 'production').split(',')
end
