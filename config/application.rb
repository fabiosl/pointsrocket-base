require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ActiveModelSerializers.config.adapter = :json

module Onrocket
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'


    if ENV['LOCALE_ENV'].present?
      Dir[ File.join(Rails.root, 'config', 'locales', ENV['LOCALE_ENV'], '*.{rb,yml}') ].each do |p|
        config.i18n.load_path << p
      end
    end

    config.i18n.available_locales = [:en, :"pt-BR"]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :'pt-BR'


    config.autoload_paths += %W( #{Rails.root.join('app', 'services')}  )
    config.autoload_paths += %W( #{Rails.root.join('app', 'flows')}  )
    config.autoload_paths += %W( #{Rails.root.join('app', 'analytics_info')}  )
    config.autoload_paths += %W( #{Rails.root.join('app', 'external_actions')}  )
    config.autoload_paths += %W( #{Rails.root.join('app', 'br_badges')}  )

    config.eager_load_paths += %W( #{Rails.root.join('app', 'services')}  )
    config.eager_load_paths += %W( #{Rails.root.join('app', 'flows')}  )
    config.eager_load_paths += %W( #{Rails.root.join('app', 'analytics_info')}  )
    config.eager_load_paths += %W( #{Rails.root.join('app', 'external_actions')}  )
    config.eager_load_paths += %W( #{Rails.root.join('app', 'br_badges')}  )

    config.middleware.use "PointsEarned"
    config.middleware.use "LastAccess"

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL',
      'Access-Control-Allow-Origin' => ENV["CORS_ORIGIN"] || "http://localhost:8080",
      'Access-Control-Request-Method' => %w{GET POST PUT DELETE OPTIONS}.join(",")
    }

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins ENV["CORS_ORIGIN"] || "*"
        resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
      end
    end

    config.action_mailer.asset_host = ENV['DEFAULT_ASSET_HOST'] || "http://#{ENV['DEFAULT_URL_HOST']}"

    config.action_mailer.default_url_options = {
        host: ENV['DEFAULT_URL_HOST']
    }

    # Isso daqui não esta funcionando porque o arquivo initializers/mail.rb
    # sobrescreve essas configurações
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address              => ENV['MAIL_ADDRESS'],
        :port                 => ENV['MAIL_PORT'],
        :user_name            => ENV['MAIL_USER_NAME'],
        :password             => ENV['MAIL_PASSWORD'],
        :domain               => ENV['MAIL_DOMAIN'],
        :authentication       => :plain,
        :enable_starttls_auto => true
    }

    config.action_dispatch.tld_length = (ENV['TLD_LENGTH'] || 1).to_i

    config.exceptions_app = self.routes
  end
end
