module CPU
  class Processor
    # Returns a Processor instance for Processor +processor_id+. If this
    # Processor doesn't exist an InvalidProcessorIdError exception is thrown.
    def initialize(processor_id, core_id = nil)
      @processor_id, @core_id = processor_id, core_id
    end

    # Returns the processor_id of this Processor, an integer in (0..(n - 1))
    # for a n-core machine.
    attr_reader :processor_id

    # Returns the core_id of this Processor.
    attr_reader :core_id

    # Returns the number of processors in this computer
    def num_processors
      CPU.num_processors
    end

    # Returns the number of cores in this computer
    def num_cores
      CPU.num_cores
    end

    # Returns an msr object and caches it.
    def msr
      @msr ||= MSR.new(processor_id)
    end

    # Returns the distance between the core temperature of this Processor and
    # its t_j_max temperature as an integer number.
    def t_j_max_distance
      (msr[0x19c] >> 16) & 0x7f
    end

    # This method returns the t_j_max temperature of this Processor if the
    # processor supports it (e. g. Intel i7 architecture) as an integer number,
    # otherwise 0 is returned.
    def t_j_max
      (msr[0x1a2] >> 16) & 0x7f
    end

    # Returns the core temperature of this Processor as an integer number. This
    # should work on all Core2 architecures if you set CPU.t_j_max
    # to the correct value for your Processor. On i7 architectures (and newer?)
    # it should work without any further configuration.
    def temperature
      my_t_j_max = t_j_max.nonzero? || CPU.t_j_max
      my_t_j_max - t_j_max_distance
    end

    def inspect
      result = "#<#{self.class}: #@processor_id"
      result << " (core#@core_id)" if @core_id
      result << '>'
    end
  end
end
