# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cpu}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = %q{2011-07-04}
  s.description = %q{Library to gather CPU information (load averages, usage, temperature) in Ruby on Linux}
  s.email = %q{flori@ping.de}
  s.executables = ["coretemp"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["CHANGES", "COPYING", "Gemfile", "README.rdoc", "Rakefile", "VERSION", "bin/coretemp", "cpu.gemspec", "lib/cpu.rb", "lib/cpu/load.rb", "lib/cpu/msr.rb", "lib/cpu/processor.rb", "lib/cpu/shared.rb", "lib/cpu/usage.rb", "lib/cpu/usage_sampler.rb", "lib/cpu/version.rb", "munin/coretemp", "tests/load_test.rb", "tests/msr_test.rb", "tests/usage_test.rb"]
  s.homepage = %q{http://flori.github.com/cpu}
  s.rdoc_options = ["--main", "README.rdoc", "--title", "CPU"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cpu}
  s.rubygems_version = %q{1.7.2}
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
