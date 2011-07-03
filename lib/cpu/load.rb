module CPU
  class Load
    include Shared

    # Create a new CPU::Load instance providing CPU load averages data.
    def initialize
      @load_data = File.open('/proc/loadavg') do |loadavg|
        loadavg.readline.split(/\s+/).first(3).map(&:to_f)
      end
    end

    # Return the load average for the last minute.
    def last_minute
      @load_data[0]
    end

    # Return the load average for the last minute, divided by the number of
    # cores.
    def last_minute_by_core
      last_minute / num_cores
    end

    # Return the load average for the last minute, divided by the number of
    # processors.
    def last_minute_by_processor
      last_minute / num_processors
    end

    # Return the load average for the last 5 minutes.
    def last_5_minutes
      @load_data[1]
    end

    # Return the load average for the last 5 minutes, divided by the number of
    # cores.
    def last_5_minutes_by_core
      last_5_minutes / num_cores
    end

    # Return the load average for the last 5 minutes, divided by the number of
    # processors.
    def last_5_minutes_by_processor
      last_5_minutes / num_processors
    end

    # Return the load average for the last 15 minutes.
    def last_15_minutes
      @load_data[2]
    end

    # Return the load average for the last 15 minutes, divided by the number of
    # cores.
    def last_15_minutes_by_core
      last_15_minutes / num_cores
    end

    # Return the load average for the last 15 minutes, divided by the number of
    # processors.
    def last_15_minutes_by_processor
      last_15_minutes / num_processors
    end

    # Return 1 minute, 5 minutes, and 15 minutes load data as an array of
    # floating point values.
    def to_a
      @load_data.dup
    end

    def inspect
      "#<#{self.class}: #{to_a * ' '}>"
    end

    alias to_s inspect
  end
end
