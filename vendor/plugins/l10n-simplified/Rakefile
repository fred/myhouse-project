require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require File.join(File.dirname(__FILE__), 'version')


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the l10n_simplified plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Create documentation for the l10n_simplified plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'LocalizationSimplified'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset=UTF-8'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


desc 'Create release packages for the l10n_simplified plugin'
Rake::PackageTask.new("l10n-simplified", L10N_VERSION) do |p|
  p.need_tar = true
  p.need_zip = true
  p.package_files.include(["lib/**/*.rb", "*.rb", "MIT-LICENSE", "README"])
end

