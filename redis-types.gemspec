# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{redis-types}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["brianthecoder"]
  s.date = %q{2009-11-14}
  s.description = %q{this is so awesome it makes grown men cry}
  s.email = %q{wbsmith83@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO",
     "VERSION",
     "example/types.rb",
     "lib/redis/counter.rb",
     "lib/redis/data_types.rb",
     "lib/redis/field_proxy.rb",
     "lib/redis/list.rb",
     "lib/redis/set.rb",
     "lib/redis/types.rb",
     "lib/redis/value.rb",
     "redis-types.gemspec",
     "spec/dump.rdb",
     "spec/redis/types_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/test.conf",
     "test/helper.rb",
     "test/test_redis-types.rb"
  ]
  s.homepage = %q{http://github.com/BrianTheCoder/redis-types}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{a way of modeling data to redis}
  s.test_files = [
    "spec/redis/types_spec.rb",
     "spec/spec_helper.rb",
     "test/helper.rb",
     "test/test_redis-types.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
  end
end

