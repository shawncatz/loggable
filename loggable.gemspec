$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "loggable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "loggable"
  s.version     = Loggable::VERSION
  s.authors     = ["Shawn Catanzarite"]
  s.email       = ["me@shawncatz.com"]
  s.homepage    = "https://github.com/shawncatz/loggable"
  s.summary     = "common logger"
  s.description = "common logger"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"
  s.add_dependency "yell", "~> 2.0.4"

  s.add_development_dependency "sqlite3"
end
