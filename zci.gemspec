require File.join([File.dirname(__FILE__), 'lib', 'zci', 'version.rb'])

Gem::Specification.new do |s|
  s.name = 'zci'
  s.version = ZCI::VERSION
  s.author = 'Anton Maminov'
  s.email = 'anton.maminov@gmail.com'
  s.homepage = 'https://github.com/mamantoha/zci'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Zendesk and Crowdin integration Command Line Interface (CLI)'
  s.files = `git ls-files`.split("\n")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'zci'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'rubyzip'
  s.add_runtime_dependency 'crowdin-api'
  s.add_runtime_dependency 'zendesk_help_center_api'
  s.add_runtime_dependency 'gli'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'aruba'
end
