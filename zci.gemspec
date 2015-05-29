# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','zci','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'zci'
  s.version = ZCI::VERSION
  s.author = 'Anton Maminov'
  s.email = 'anton.maminov@gmail.com'
  s.homepage = 'https://github.com/mamantoha/zci'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Zendesk and Crowdin integration Command Line Interface (CLI)'
  s.files = `git ls-files`.split("\n")
  s.require_paths << 'lib'
  # s.has_rdoc = true
  # s.extra_rdoc_files = ['README.rdoc','zci.rdoc']
  # s.rdoc_options << '--title' << 'zci' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'zci'
  s.add_runtime_dependency('nokogiri')
  s.add_runtime_dependency('rubyzip')
  s.add_runtime_dependency('crowdin-api')
  s.add_runtime_dependency('zendesk_api')
  s.add_runtime_dependency('zendesk_help_center_api')
  s.add_runtime_dependency('gli','2.13.0')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('byebug')
end
