module CPU
  class Load
    include Shared

    def initialize
      @load_data = File.open('/proc/loadavg') do |loadavg|
        loadavg.readline.split(/\s+/).first(3).map(&:to_f)
      end
    end

    def last_minute
      @load_data[0]
    end

    def last_minute_by_core
      last_minute / num_cores
    end

    def last_minute_by_processor
      last_minute / num_processors
    end

    def last_5_minutes
      @load_data[1]
    end

    def last_5_minutes_by_core
      last_5_minutes / num_cores
    end

    def last_5_minutes_by_processor
      last_5_minutes / num_processors
    end

    def last_15_minutes
      @load_data[2]
    end

    def last_15_minutes_by_core
      last_15_minutes / num_cores
    end

    def last_15_minutes_by_processor
      last_15_minutes / num_processors
    end

    def to_a
      @load_data.dup
    end

    def inspect
      "#<#{self.class}: #{to_a * ' '}>"
    end

    alias to_s inspect
  end
end
