module CPU
  class Usage < Struct.new('Usage', :usage, :processor_id, :user, :nice,
                           :system, :idle, :start_at, :stop_at)
    include Shared

    # Add this CPU::Usage instance to the other and return a resulting sum object.
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

    # Subtract the other from this CPU::Usage instance the other and return a
    # resulting difference object.
    def -(other)
      self + other * -1
    end

    # Multiply the cpu times in this CPU::Usage instance with +scalar+.
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

    # Divide the cpu times in this CPU::Usage instance by +scalar+.
    def /(scalar)
      self * (1.0 / scalar)
    end

    # Return the cpu time that where used to process instructions since booting
    # up the system.
    def process_time
      user + nice + system
    end

    # Return the real time passed in the range of all CPU::Usage instances,
    # that were used to create this summed up CPU::Usage instance. If this
    # isn't a sum object, this value will be 0.0.
    def real_time
      stop_at - start_at
    end

    # Return the total cpu time that has passed since booting the system.
    def total_time
      values_at(2..-3).inject(0.0) { |s,  x| s + x }
    end

    # Return the CPU usage as a percentage number between 0.0..100.0.
    def percentage(time = total_time)
      100.0 * process_time / time
    end

    def inspect
      "#<#{self.class}: #{percentage}>"
    end

    alias to_s inspect
  end
end
