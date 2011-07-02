module CPU
  class MSR
    # Returns true if the msr functionality is already available in the kernel
    # (either compiled into it or via a module).
    def self.available?
      File.exist?('/dev/cpu/0/msr')
    end

    # Loads the msr module and sleeps for a second afterwards.
    def self.load_msr_module
      system "#{CPU.modprobe_path} msr"
      sleep 1
    end

    def initialize(processor_id)
      self.class.available? or self.class.load_module
      begin
        @io = IO.new IO.sysopen('/dev/cpu/%d/msr' % processor_id, 'rb')
      rescue Errno::ENOENT
        raise InvalidProcessorIdError, "'#{processor_id}' is not a valid processor_id on this machine"
      end
    end

    # Returns the byte at +offset+ as an integer number.
    def [](offset)
      @io.sysseek(offset)
      data, = @io.sysread(8).unpack('q')
      data
    end
  end
end
