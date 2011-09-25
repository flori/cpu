# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'cpu'
  path_module 'CPU'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://flori.github.com/#{name}"
  summary     'CPU information in Ruby/Linux'
  description 'Library to gather CPU information (load averages, usage,'\
              ' temperature) in Ruby on Linux'

  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock'
  readme      'README.rdoc'
  executables 'coretemp'

  dependency  'tins',           '~>0.3'
  dependency  'more_math',      '~>0.0'

  install_library do
    libdir = CONFIG["sitelibdir"]
    cd 'lib' do
      dst = File.join(libdir, 'cpu')
      mkdir_p dst
      cd 'cpu' do
        for file in Dir['*.rb']
          install file, File.join(dst, file)
        end
      end
      install 'cpu.rb', libdir
    end
    install('bin/coretemp', bindir, :verbose => true, :mode => 0755) 
  end
end
