$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "metova/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "metova"
  s.version     = Metova::VERSION
  s.authors     = ["Logan Serman"]
  s.email       = ["loganserman@gmail.com"]
  s.homepage    = "http://github.com/metova/metova"
  s.summary     = "TODO: Summary of Metova."
  s.description = "TODO: Description of Metova."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 4.2.0.rc3'
  s.add_dependency 'kaminari', '~> 0.16.0'
  s.add_dependency 'devise', '>= 3.2.0'
  s.add_dependency 'responders', '~> 2.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"

end
