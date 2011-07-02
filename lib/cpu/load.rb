module CPU
  class Load
    def initialize
      line = File.open('/proc/loadavg') { |file| file.readline }
      @load_data = line.split(/\s+/).first(3).map(&:to_f)
    end

    def last_minute
      @load_data[0]
    end

    def last_minute_by_core
      last_minute / CPU.num_cores
    end

    def last_minute_by_processor
      last_minute / CPU.num_processors
    end

    def last_5_minutes
      @load_data[1]
    end

    def last_5_minutes_by_core
      last_5_minutes / CPU.num_cores
    end

    def last_5_minutes_by_processor
      last_5_minutes / CPU.num_processors
    end

    def last_15_minutes
      @load_data[2]
    end

    def last_15_minutes_by_core
      last_15_minutes / CPU.num_cores
    end

    def last_15_minutes_by_processor
      last_15_minutes / CPU.num_processors
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
