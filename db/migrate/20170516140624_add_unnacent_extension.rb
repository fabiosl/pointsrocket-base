class AddUnnacentExtension < ActiveRecord::Migration
  def up
    execute('CREATE SCHEMA IF NOT EXISTS shared_extensions;')
    execute('CREATE EXTENSION IF NOT EXISTS unaccent SCHEMA shared_extensions;')
  end
end
