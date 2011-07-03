# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cpu}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Florian Frank}]
  s.date = %q{2011-07-03}
  s.description = %q{Library to gather CPU information (load averages, usage, temperature) in Ruby on Linux}
  s.email = %q{flori@ping.de}
  s.executables = [%q{coretemp}]
  s.extra_rdoc_files = [%q{README.rdoc}]
  s.files = [%q{CHANGES}, %q{COPYING}, %q{Gemfile}, %q{README.rdoc}, %q{Rakefile}, %q{VERSION}, %q{bin/coretemp}, %q{cpu.gemspec}, %q{lib/cpu.rb}, %q{lib/cpu/load.rb}, %q{lib/cpu/msr.rb}, %q{lib/cpu/processor.rb}, %q{lib/cpu/shared.rb}, %q{lib/cpu/usage.rb}, %q{lib/cpu/usage_sampler.rb}, %q{lib/cpu/version.rb}, %q{munin/coretemp}, %q{tests/load_test.rb}, %q{tests/msr_test.rb}, %q{tests/usage_test.rb}]
  s.homepage = %q{http://flori.github.com/cpu}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}, %q{--title}, %q{CPU}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{cpu}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{CPU information in Ruby/Linux}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spruz>, ["~> 0.2.2"])
    else
      s.add_dependency(%q<spruz>, ["~> 0.2.2"])
    end
  else
    s.add_dependency(%q<spruz>, ["~> 0.2.2"])
  end
end
