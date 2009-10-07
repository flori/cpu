# This module provides (read) access to the Model Specific Registers of Intel
# CPUs on Linux.
module MSR

  class << self
    attr_accessor :modprobe_path
  end
  self.modprobe_path = '/sbin/modprobe'

  class CPU
    class << self
      attr_accessor :t_j_max
    end
    self.t_j_max = 95

    # Returns a CPU instance for CPU +cpuid+. If this CPU doesn't exist, a XXX
    # exception is thrown.
    def initialize(cpuid)
      @cpuid = cpuid
      MSR.available? or MSR.load_module
      @io = IO.new IO.sysopen('/dev/cpu/%d/msr' % @cpuid, 'rb')
    end

    attr_reader :cpuid

    def [](byte)
      @io.sysseek(byte)
      data, = @io.sysread(8).unpack('q')
      data
    end

    def t_j_max_distance
      (self[0x19c] >> 16) & 0x7f
    end

    def t_j_max
      (self[0x1a2] >> 16) & 0x7f
    end

    def temperature
      self.class.t_j_max - t_j_max_distance
    end
  end

  class << self
    def cpus
      MSR.available? or MSR.load_module
      cpus = Dir.open('/dev/cpu').inject([]) do |c, cpuid|
        cpuid =~ /\A\d+\Z/ or next c
        c << cpuid.to_i
      end
      cpus.sort!
      cpus.map! { |c| CPU.new(c) }
    end

    alias to_a cpus

    def each_cpu(&block)
      cpus.each(&block)
    end

    alias each each_cpu

    include Enumerable

    def available?
      File.exist?('/dev/cpu/0/msr')
    end

    def load_module
      system "#{self.modprobe_path} msr"
      sleep 1
    end
  end
end
