module CPU
  class UsageSampler
    # Creates a new UsageSampler instance.
    def initialize
      sample
    end

    # Return all CPU::Usage instances stored in this UsageSampler, if any.
    attr_reader :usages

    # Returns a CPU::Usage instance, that sums up all CPU::Usage instances for
    # all processors in this computer.
    def sum_usages
      @usages and @usages.values.inject(&:+)
    end

    # This regular expression is used to parse cpu times from the /proc/stat
    # kernel file.
    CPU = /^cpu(\d+)#{'\s+(\d+)' * 4}/

    # This value is used to convert cpu times from jiffies into seconds.
    USER_HZ = 100

    # Take one sample of CPU usage data for every processor in this computer
    # and store them in the +usages+ attribute.
    def sample
      @usages = {}
      timestamp = Time.now
      File.foreach('/proc/stat') do |line|
        case line
        when /^cpu[^\d]/
          next
        when CPU
          times = $~.captures
          processor_id = times[0] = times[0].to_i
          (1...times.size).each { |i| times[i] = times[i].to_f / USER_HZ }
          times << timestamp << timestamp
          @usages[processor_id] = Usage.new(self, *times)
        else
          break
        end
      end
      if @usages.empty?
        raise NoSampleDataError, "could not sample measurement data"
      end
      self
    end
  end
end
