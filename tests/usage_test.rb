require 'test/unit'
require 'mocha'
require 'cpu'

module CPU
  class UsageTest < Test::Unit::TestCase
    def test_sum_usage
      @processor = CPU.sum_usage 0.1
      assert_kind_of Processor, @processor
      assert_operator @processor.usage.percentage, :>, 0
    end
  end
end

