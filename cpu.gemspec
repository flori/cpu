# -*- encoding: utf-8 -*-
# stub: cpu 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "cpu"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florian Frank"]
  s.date = "2015-06-03"
  s.description = "Library to gather CPU information (load averages, usage, temperature) in Ruby on Linux"
  s.email = "flori@ping.de"
  s.executables = ["coretemp"]
  s.extra_rdoc_files = ["README.rdoc", "lib/cpu.rb", "lib/cpu/load.rb", "lib/cpu/msr.rb", "lib/cpu/processor.rb", "lib/cpu/shared.rb", "lib/cpu/usage.rb", "lib/cpu/usage_sampler.rb", "lib/cpu/version.rb"]
  s.files = [".gitignore", "CHANGES", "COPYING", "Gemfile", "README.rdoc", "Rakefile", "VERSION", "bin/coretemp", "cpu.gemspec", "lib/cpu.rb", "lib/cpu/load.rb", "lib/cpu/msr.rb", "lib/cpu/processor.rb", "lib/cpu/shared.rb", "lib/cpu/usage.rb", "lib/cpu/usage_sampler.rb", "lib/cpu/version.rb", "munin/coretemp", "tests/load_test.rb", "tests/msr_test.rb", "tests/usage_test.rb"]
  s.homepage = "https://github.com/flori/cpu"
  s.rdoc_options = ["--title", "Cpu - CPU information in Ruby/Linux", "--main", "README.rdoc"]
  s.rubygems_version = "2.2.2"
  s.summary = "CPU information in Ruby/Linux"
  s.test_files = ["tests/load_test.rb", "tests/msr_test.rb", "tests/usage_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<tins>, ["~> 1.0"])
      s.add_runtime_dependency(%q<more_math>, ["~> 0.0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_dependency(%q<tins>, ["~> 1.0"])
      s.add_dependency(%q<more_math>, ["~> 0.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
    s.add_dependency(%q<tins>, ["~> 1.0"])
    s.add_dependency(%q<more_math>, ["~> 0.0"])
  end
end
