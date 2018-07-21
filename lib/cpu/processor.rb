module CPU
  class Processor
    include Shared

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

    # Returns an msr object and caches it.
    def msr
      @msr ||= MSR.new(processor_id)
    end

    attr_writer :usage

    # Measure CPU usage for this Processor instance during the next +interval+
    # or during the runtime of the given block. Іf CPU usage on all processors
    # of the system should be measured, it's better (=faster) to use the
    # CPU.usage method instead.
    def usage(interval = 1, &block)
      unless @usage
        if processor = CPU.usage(interval, &block).find {
          |p| p.processor_id == processor_id
        }
        then
          @usage = processor.usage
        end
      end
      @usage
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
      if defined?(@temperature)
        @temperature
      else
        my_t_j_max = t_j_max.nonzero? || CPU.t_j_max
        my_t_j_max - t_j_max_distance
      end
    end

    attr_writer :temperature

    def inspect
      if processor_id >= 0
        result = "#<#{self.class}: #@processor_id"
        result << " (core#@core_id)" if @core_id
        result << '>'
      else
        "#<#{self.class}: total>"
      end
    end
  end
end
