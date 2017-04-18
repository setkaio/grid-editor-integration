$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "grid/editor_integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "grid-editor-integration"
  s.version     = Grid::EditorIntegration::VERSION
  s.authors     = ["sov-87"]
  s.email       = ["a_fetisov@setka.io"]
  s.homepage    = "https://github.com/sov-87/grid-editor-integration"
  s.summary     = "Setka Editor"
  s.description = "Integrate Setka Editor into your system"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'aws-sdk-v1'
end
