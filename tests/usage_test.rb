require 'test/unit'
require 'cpu'

module CPU
  class UsageTest < Test::Unit::TestCase
    def test_sum_usage
      @processor = CPU.sum_usage_processor 1
      assert_kind_of Processor, @processor
      assert_operator @processor.usage.percentage, :>, 0
    end
  end
end

