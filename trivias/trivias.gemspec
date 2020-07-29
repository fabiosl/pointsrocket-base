$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trivias/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trivias"
  s.version     = Trivias::VERSION
  s.authors     = ["Manoel Quirino Neto"]
  s.email       = ["contato@manoelneto.com"]
  s.homepage    = ""
  s.summary     = "Summary of Trivias."
  s.description = "Description of Trivias."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "rabl", "0.12.0"

  s.add_development_dependency "annotate", "2.6.5"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "awesome_print", "1.6.1"
end
