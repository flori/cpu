require 'test/unit'
require 'cpu'

module CPU
  class MSRTest < Test::Unit::TestCase
    def setup
      @cpu0, @cpu1 = CPU.to_a
    end

    def test_loaded
      assert CPU::MSR.available?
    end

    def test_instance
      assert_kind_of CPU::Processor, @cpu0
      assert_equal 0, @cpu0.processor_id
      assert_kind_of CPU::Processor, @cpu1
      assert_equal 1, @cpu1.processor_id
    end

    def test_temperature
      assert_operator @cpu0.temperature, '>', 0
      assert_operator @cpu1.temperature, '>', 0
    end
  end
end
