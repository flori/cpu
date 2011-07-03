module CPU
  class Usage < Struct.new('Usage', :usage, :processor_id, :user, :nice,
                           :system, :idle, :start_at, :stop_at)
    include Shared

    def +(other)
      self.class.new(*(
        [
          usage,
          processor_id == other.processor_id ? processor_id : 0,
        ] +
        values_at(2..-3).zip(other.values_at(2..-3)).map { |x, y| x + y } +
        [
          [ start_at, other.start_at ].min,
          [ stop_at, other.stop_at ].max
        ])
      )
    end

    def -(other)
      self + other * -1
    end

    def *(scalar)
      scalar = scalar.to_f
      self.class.new(*(
        [
          usage,
          processor_id,
        ] +
        values_at(2..-3).map { |x| x * scalar } +
        [
          start_at,
          stop_at,
        ])
      )
    end

    def /(scalar)
      self * (1.0 / scalar)
    end

    def process_time
      user + nice + system
    end

    def real_time
      stop_at - start_at
    end

    def total_time
      values_at(2..-3).inject(0.0) { |s,  x| s + x }
    end

    def percentage(time = total_time)
      100.0 * process_time / time
    end

    def inspect
      "#<#{self.class}: #{percentage}>"
    end

    alias to_s inspect
  end
end
