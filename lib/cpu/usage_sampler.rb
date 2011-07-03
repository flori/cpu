module CPU
  class UsageSampler
    def initialize
      sample
    end

    attr_reader :usages

    def sum_usages
      @usages and @usages.values.inject(&:+)
    end

    CPU = /^cpu(\d+)#{'\s+(\d+)' * 4}/

    USER_HZ = 100

    def sample
      total, @usages = nil, {}
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
