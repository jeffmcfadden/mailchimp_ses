require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mailchimp_ses"
  gem.homepage = "http://github.com/dbalatero/mailchimp_ses"
  gem.license = "MIT"
  gem.summary = %Q{Gives API methods for MailChimp SES.}
  gem.description = %Q{Allows you to call MailChimp <-> Amazon SES integration methods.}
  gem.email = "dbalatero@gmail.com"
  gem.authors = ["David Balatero"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'

  gem.add_development_dependency 'rspec', '~> 2.3.0'
  gem.add_development_dependency 'jeweler', '~> 1.5.2'
  gem.add_development_dependency 'vcr'
  gem.add_runtime_dependency 'monster_mash', '>= 0.2.2'
  gem.add_runtime_dependency 'json'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mailchimp_ses #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
