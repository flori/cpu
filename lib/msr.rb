# This module provides (read) access to the Model Specific Registers of Intel
# CPUs on Linux.
module MSR

  # This exception is thrown if an invalid CPUId is queried.
  class InvalidCPUIdError < StandardError; end

  class << self
    # The path to the modprobe binary which is used to load the msr module if
    # necessary.
    attr_accessor :modprobe_path
  end
  self.modprobe_path = '/sbin/modprobe'

  class CPU
    class << self
      # The t_j_max temperature of that is used as a default for this CPU if it
      # cannot be queried (e.g. Core2 architecture). It defaults to 95 which is
      # the correct value for Core2 Duo E8400 (Wolfsdale). Be sure to set the
      # correct value for your Core2 CPU here, otherwise your temperature
      # measurements will be incorrect.
      attr_accessor :t_j_max
    end
    self.t_j_max = 95

    # Returns a CPU instance for CPU +cpuid+. If this CPU doesn't exist an
    # InvalidCPUIdError exception is thrown.
    def initialize(cpuid)
      @cpuid = cpuid
      MSR.available? or MSR.load_module
      begin
        @io = IO.new IO.sysopen('/dev/cpu/%d/msr' % @cpuid, 'rb')
      rescue Errno::ENOENT
        raise InvalidCPUIdError, "'#{cpuid}' is not a valid cpuid on this machine"
      end
    end

    # Returns the cpuid of this CPU, an integer in (0..(n - 1)) for a n-core
    # machine.
    attr_reader :cpuid

    # Returns the byte at +offset+ as an integer number.
    def [](offset)
      @io.sysseek(offset)
      data, = @io.sysread(8).unpack('q')
      data
    end

    # Returns the distance between the core temperature of this CPU and its
    # t_j_max temperature as an integer number.
    def t_j_max_distance
      (self[0x19c] >> 16) & 0x7f
    end

    # This method returns the t_j_max temperature of this CPU if the processor
    # supports it (e. g. Intel i7 architecture) as an integer number, otherwise
    # 0 is returned.
    def t_j_max
      (self[0x1a2] >> 16) & 0x7f
    end

    # Returns the core temperature of this CPU as an integer number. This
    # should work on all Core2 architecures if you set MSR::CPU.t_j_max to the
    # correct value for your CPU. On i7 architectures (and newer?) it should
    # work without any further configuration.
    def temperature
      my_t_j_max = t_j_max.nonzero? || self.class.t_j_max
      my_t_j_max - t_j_max_distance
    end
  end

  class << self
    # Return an array of all CPU instances for this machine.
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

    # Iterate over each CPU instance for this machine and yield to the block
    # for each of them.
    def each_cpu(&block)
      cpus.each(&block)
    end

    alias each each_cpu

    include Enumerable

    # Returns true if the msr functionality is already available in the kernel
    # (either compiled into it or via a module).
    def available?
      File.exist?('/dev/cpu/0/msr')
    end

    # Loads the msr module and sleeps for a second afterwards.
    def load_module
      system "#{self.modprobe_path} msr"
      sleep 1
    end
  end
end
