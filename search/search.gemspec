$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "search/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "search"
  s.version     = Search::VERSION
  s.authors     = ["Manoel Quirino Neto"]
  s.email       = ["contato@manoelneto.com"]
  s.homepage    = "https://pointsrocket.com.br"
  s.summary     = "Indexer of models to search all of them"
  s.description = "Indexer of models to search all of them."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "orm_adapter", "~> 0.1"
  s.add_dependency "ransack", "~> 1.3"
  s.add_dependency 'will_paginate', '3.0.5'

  s.add_development_dependency "annotate", "2.6.5"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "awesome_print", "1.6.1"
end
