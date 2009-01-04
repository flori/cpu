module MSR
  class CPU
    # Returns a CPU instance for CPU +number+. If this CPU doesn't exist,
    # a XXX exception is thrown.
    def initialize(number)
      @number = number
      MSR.loaded? or MSR.load
      @file = IO.new IO.sysopen('/dev/cpu/%d/msr' % @number, 'rb')
    end

    attr_reader :number

    def [](byte)
      @file.sysseek(byte)
      data, = @file.sysread(8).unpack('q')
      data
    end

    def temperature
      95 - (self[0x19c] >> 16) & 0x7f
    end
  end

  class << self
    def to_a
      MSR.loaded? or MSR.load
      cpus = Dir.open('/dev/cpu').inject([]) do |c, number|
        number =~ /\A\d+\Z/ or next c
        c << number.to_i
      end
      cpus.sort!
      cpus.map! { |c| CPU.new(c) }
    end

    def each(&block)
      to_a.each(&block)
    end
    include Enumerable
  end

  module_function

  def loaded?
    File.open('/proc/modules') { |f| f.any? { |line| line =~ /^msr\s/ } }
  end

  def load
    system '/sbin/modprobe msr'
    sleep 1
  end
end
