$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "token_login/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "token_login"
  s.version     = TokenLogin::VERSION
  s.authors     = ["Manoel Quirino Neto"]
  s.email       = ["contato@manoelneto.com"]
  s.homepage    = ""
  s.summary     = "Summary of TokenLogin."
  s.description = "Description of TokenLogin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
