# Be sure to restart your server when you modify this file.
if ENV["MASTER_DOMAIN"].present? and ENV['SUBDOMAIN_AS_COMMUNITIES'] != 'false'
  domain_for_session = ".#{(ENV["MASTER_DOMAIN"] || "lvh.me").split(':').first}"
  Rails.application.config.session_store :cookie_store, key: '_onrocket_session', domain: domain_for_session
else
  Rails.application.config.session_store :cookie_store, key: '_points_session'
end
