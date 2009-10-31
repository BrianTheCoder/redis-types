require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "redis-types"
    gem.summary = %Q{TODO: a port of redis-model to a module for composition}
    gem.description = %Q{TODO: this is my port of redis-module because I prefer composition over inheritance, cause then you can combine it with other orms. I also changed json parsing to yajl-ruby and tweaked a few other things to my preferences}
    gem.email = "wbsmith83@gmail.com"
    gem.homepage = "http://github.com/BrianTheCoder/redis-types"
    gem.authors = ["brianthecoder"]
    gem.add_development_dependency "rspec", ">= 0"
    gem.add_dependency "redis-rb"
    gem.add_dependency "yajl-ruby"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "redis-types #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
