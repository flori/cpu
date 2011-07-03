# vim: set filetype=ruby et sw=2 ts=2:

begin
  require 'rubygems/package_task'
rescue LoadError
end
begin
  require 'rcov/rcovtask'
rescue LoadError
end
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

PKG_NAME    = 'cpu'
PKG_VERSION = File.read('VERSION').chomp
PKG_FILES   = FileList[*`git ls-files`.split(/\n/)].exclude '.gitignore'
CLEAN.include 'coverage', 'doc'
CLOBBER.include 'pkg'

desc "Install executable/library into site_ruby directories"
task :install  do
  bindir = CONFIG['bindir']
  libdir = CONFIG['sitelibdir']
  cd 'lib' do
    for file in Dir['**/*.rb']
      dest = File.join(libdir, file)
      mkdir_p File.dirname(dest)
      install file, dest, :verbose => true
    end
  end
  install('bin/coretemp', bindir, :verbose => true, :mode => 0755)
end

desc "Create documentation"
task :doc do
  sh "sdoc -m README.rdoc -t 'CPU' README.rdoc #{Dir['lib/**/*.rb'] * ' '}"
end

namespace :gems do
  desc "Install all gems from the Gemfile"
  task :install  do
    sh 'bundle install'
  end
end

if defined? Gem
  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.summary = "CPU information in Ruby/Linux"
    s.description = "Library to gather CPU information (load averages, usage,"\
      " temperature) in Ruby on Linux"

    s.executables = 'coretemp'
    s.files = PKG_FILES

    s.require_path = 'lib'

    s.add_dependency 'spruz', '~>0.2.2'

    s.rdoc_options << '--main' <<  'README.rdoc' << '--title' << 'CPU'
    s.extra_rdoc_files << 'README.rdoc'
    s.test_files.concat Dir['tests/test_*.rb']

    s.author = "Florian Frank"
    s.email = "flori@ping.de"
    s.homepage = "http://flori.github.com/#{PKG_NAME}"
    s.rubyforge_project = PKG_NAME
  end

  desc 'Create a gemspec file'
  task :gemspec => :version do
    File.open('cpu.gemspec', 'w') do |gemspec|
      gemspec.write spec.to_ruby
    end
  end

  Gem::PackageTask.new(spec) do |pkg|
    pkg.need_tar = true
    pkg.package_files += PKG_FILES
  end
end


Rake::TestTask.new do |t|
  t.test_files = FileList['tests/**/*_test.rb']
  t.verbose    = true
end

if defined? Rcov
  Rcov::RcovTask.new do |t|
    t.test_files = FileList['tests/**/*_test.rb']
    t.verbose    = true
    t.rcov_opts = %w[-x '\\btests\/' -x '\\bgems\/']
  end
end

desc m = "Writing version information for #{PKG_VERSION}"
task :version do
  puts m
  File.open(File.join('lib', 'cpu', 'version.rb'), 'w') do |v|
    v.puts <<EOT
module CPU
  # CPU version
  VERSION         = '#{PKG_VERSION}'
  VERSION_ARRAY   = VERSION.split(/\\./).map { |x| x.to_i } # :nodoc:
  VERSION_MAJOR   = VERSION_ARRAY[0] # :nodoc:
  VERSION_MINOR   = VERSION_ARRAY[1] # :nodoc:
  VERSION_BUILD   = VERSION_ARRAY[2] # :nodoc:
end
EOT
  end
end

desc "Run the tests by default"
task :default => [ :version, :test ]

desc "Prepare release of the library"
task :release => [ :clean, :gemspec, :package ]
