#!/usr/bin/env ruby

require 'rbconfig'
include Config
require 'fileutils'
include FileUtils::Verbose

bin_dir = CONFIG['bindir']
lib_dir = CONFIG['sitelibdir']

install 'lib/msr.rb', lib_dir
mkdir_p bin_dir
for file in Dir['bin/*']
  install file, bin_dir
end
