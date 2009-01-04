# This module provides (read) access to the Model Specific Registers of Intel
# CPUs on Linux.
module MSR
  class CPU
    class << self
      attr_accessor :t_j_max

      attr_accessor :modprobe_path
    end
    self.t_j_max = 95
    self.modprobe_path = '/sbin/modprobe'

    # Returns a CPU instance for CPU +cpuid+. If this CPU doesn't exist, a XXX
    # exception is thrown.
    def initialize(cpuid)
      @cpuid = cpuid
      MSR.loaded? or MSR.load
      @file = IO.new IO.sysopen('/dev/cpu/%d/msr' % @cpuid, 'rb')
    end

    attr_reader :cpuid

    def [](byte)
      @file.sysseek(byte)
      data, = @file.sysread(8).unpack('q')
      data
    end

    def temperature
      self.class.t_j_max - (self[0x19c] >> 16) & 0x7f
    end
  end

  class << self
    def cpus
      MSR.loaded? or MSR.load
      cpus = Dir.open('/dev/cpu').inject([]) do |c, cpuid|
        cpuid =~ /\A\d+\Z/ or next c
        c << cpuid.to_i
      end
      cpus.sort!
      cpus.map! { |c| CPU.new(c) }
    end

    alias to_a cpus

    def each_cpu(&block)
      to_a.each(&block)
    end

    alias each each_cpu

    include Enumerable

    def loaded?
      File.open('/proc/modules') { |f| f.any? { |line| line =~ /^msr\s/ } }
    end

    def load
      system "#{self.class.modprobe_path} msr"
      sleep 1
    end
  end
end
