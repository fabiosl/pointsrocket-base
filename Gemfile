source 'http://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '2.1.5'
gem 'rails', '4.1.8'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See http://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'apartment'
gem 'active_model_serializers', '~> 0.10.0'
gem 'rinku'

source 'http://rails-assets.org' do
  gem 'rails-assets-i18next'
  gem 'rails-assets-ng-i18next'
  gem 'rails-assets-angular-sanitize'
  gem 'rails-assets-selectize'
  gem 'rails-assets-lodash'
  gem 'rails-assets-summernote'
  gem 'rails-assets-readmore'
  gem 'rails-assets-jquery-text-counter'
  # gem 'rails-assets-jquery.atwho'
end

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'compass-rails'
# Turbolinks makes following links in your web application faster. Read more: http://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: http://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'angularjs-rails'
gem 'angular-rails-templates'

gem 'pg'
# gem 'underscore-rails'

group :production do

  # Use the Unicorn app server
  gem 'unicorn'

  gem 'exception_notification'

  gem "newrelic_rpm"

end


# Spring speeds up development by keeping your application running in the background. Read more: http://github.com/rails/spring
group :development do
  gem 'spring'
  gem 'pry'

  # deploy
  gem 'capistrano', '~> 3.8.1'

  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1.0'

  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  # if you are using RBENV
  gem 'capistrano-rbenv', "~> 2.0"

  # gem 'slackistrano'

  gem 'pry-rails'
  gem 'pry-doc'

  gem "annotate"
  gem 'guard-annotate'
  gem 'guard-rails'
  gem "binding_of_caller"
  gem "better_errors"
  gem 'quiet_assets'
  gem "capistrano-db-tasks", require: false, github: 'manoelneto/capistrano-db-tasks'
  gem 'yard'
  gem 'slackistrano', "3.8.1"
  gem 'i18n-tasks', '~> 0.9.15'
  gem "thin"
  gem "newrelic_rpm"
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  # gem 'capybara'
  # gem 'selenium-webdriver'
  # gem 'poltergeist'
  gem 'ffaker'
  gem 'vcr'
  # gem 'rack-timer'
end

group :test do
  gem 'webmock'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'guard-rspec', require: false
  gem 'spring-commands-rspec'
end

gem 'awesome_print', '1.6.1', require: "ap"

gem 'draper'

gem "non-stupid-digest-assets"

# slug
gem 'friendly_id', '~> 5.0.0'

gem 'httpclient'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-instagram', github: 'manoelneto/omniauth-instagram'
gem 'omniauth-google-oauth2'
gem 'linkedin'
gem 'youtube'
gem 'google-api-client', '0.10.0'
gem 'trollop'
gem 'launchy'


gem 'attr_encrypted'

gem 'kaminari' # adds pagination to ActiveModels

gem 'jquery-validation-rails'
gem 'email_validator'

# mandril/email
# gem 'mandrill_mailer'

gem 'paperclip'
gem 'open_uri_redirections'
gem 'figaro'

gem 'activeadmin', github: 'activeadmin'
# gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
# gem 'activeadmin-wysihtml5', github: 'stefanoverna/activeadmin-wysihtml5'

# datetime picker
gem 'just-datetime-picker'



gem 'language_list', github: 'scsmith/language_list', tag: 'v1.1.0'

gem 'country_select'

gem 'will_paginate', '3.0.5'
gem 'will_paginate-bootstrap'

gem 'carrierwave'

# for search
gem 'has_scope'

# markdown
gem 'redcarpet'
gem 'albino'
# gem 'nokogiri'

gem 'cancancan', '~> 1.15'
gem 'draper-cancancan'

gem 'ransack'

gem 'sinatra', :require => nil
gem 'sidekiq'
gem "sidekiq-cron"
gem 'sidekiq_parameters_logging'

gem 'token_login', path: 'token_login'

gem 'trivias', path: 'trivias'
gem 'search', path: 'search'

gem 'zeroclipboard-rails'
gem 'acts-as-taggable-on', '~> 3.4'

gem "rmagick"

gem "httparty", "0.13.3"
gem "twitter"
gem 'jquery-atwho-rails', '~> 1.3.2'

# apple push notification
gem "apns"

# google firebase
gem "fcm"
gem "spreadsheet"
gem "ruby_dig"

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'mobylette'
gem 'rack-cors', :require => 'rack/cors'

gem "jwt"

gem "bugsnag", "~> 6.8"
gem 'slugify', '~> 1.0', '>= 1.0.7'