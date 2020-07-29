namespace :db do
  task :extensions => :environment do
    ActiveRecord::Base.connection.execute('CREATE SCHEMA IF NOT EXISTS shared_extensions;')
    ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS unaccent SCHEMA shared_extensions;')
  end
end

Rake::Task['db:create'].enhance do
  Rake::Task['db:extensions'].invoke
end

Rake::Task['db:test:purge'].enhance do
  Rake::Task['db:extensions'].invoke
end