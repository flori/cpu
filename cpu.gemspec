# -*- encoding: utf-8 -*-
# stub: cpu 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "cpu".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2018-07-21"
  s.description = "Library to gather CPU information (load averages, usage, temperature) in Ruby on Linux".freeze
  s.email = "flori@ping.de".freeze
  s.executables = ["coretemp".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "lib/cpu.rb".freeze, "lib/cpu/load.rb".freeze, "lib/cpu/msr.rb".freeze, "lib/cpu/processor.rb".freeze, "lib/cpu/shared.rb".freeze, "lib/cpu/usage.rb".freeze, "lib/cpu/usage_sampler.rb".freeze, "lib/cpu/version.rb".freeze]
  s.files = [".gitignore".freeze, "CHANGES".freeze, "COPYING".freeze, "Gemfile".freeze, "README.rdoc".freeze, "Rakefile".freeze, "VERSION".freeze, "bin/coretemp".freeze, "cpu.gemspec".freeze, "lib/cpu.rb".freeze, "lib/cpu/load.rb".freeze, "lib/cpu/msr.rb".freeze, "lib/cpu/processor.rb".freeze, "lib/cpu/shared.rb".freeze, "lib/cpu/usage.rb".freeze, "lib/cpu/usage_sampler.rb".freeze, "lib/cpu/version.rb".freeze, "munin/coretemp".freeze, "tests/load_test.rb".freeze, "tests/msr_test.rb".freeze, "tests/test_helper.rb".freeze, "tests/usage_test.rb".freeze]
  s.homepage = "https://github.com/flori/cpu".freeze
  s.rdoc_options = ["--title".freeze, "Cpu - CPU information in Ruby/Linux".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "CPU information in Ruby/Linux".freeze
  s.test_files = ["tests/load_test.rb".freeze, "tests/msr_test.rb".freeze, "tests/test_helper.rb".freeze, "tests/usage_test.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.9.1"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<tins>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<more_math>.freeze, ["~> 0.0"])
    else
      s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.9.1"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<tins>.freeze, ["~> 1.0"])
      s.add_dependency(%q<more_math>.freeze, ["~> 0.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.9.1"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<tins>.freeze, ["~> 1.0"])
    s.add_dependency(%q<more_math>.freeze, ["~> 0.0"])
  end
end
