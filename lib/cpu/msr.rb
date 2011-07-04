module CPU
  class MSR
    # Returns true if the msr functionality is already available in the kernel
    # (either compiled into it or via a module).
    def self.available?
      File.exist?('/dev/cpu/0/msr')
    end

    # Loads the msr module and sleeps for a second afterwards.
    def self.load_module
      system "#{CPU.modprobe_path} msr"
      sleep 1
    end

    # Create a new wrapper for the msr kernel file associated with
    # +processor_id+.
    def initialize(processor_id)
      self.class.available? or self.class.load_module
      begin
        name = '/dev/cpu/%d/msr' % processor_id
        @io = IO.new IO.sysopen(name, 'rb')
      rescue Errno::ENOENT
        raise InvalidProcessorIdError, "'#{processor_id}' is not a valid processor_id on this machine"
      rescue StandardError => e
        raise NoSampleDataError, "could not read temperature from #{name}: #{e}"
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
