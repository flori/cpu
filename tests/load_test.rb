require 'test/unit'
require 'mocha'
require 'cpu'

module CPU
  class LoadTest < Test::Unit::TestCase
    def test_load_minutes
      @load = CPU.load
      @load.stubs(:num_processors).returns(4)
      @load.stubs(:num_cores).returns(2)
      for v in %w[last_minute last_5_minutes last_15_minutes]
        assert_kind_of Float, @load.__send__(v)
        assert_operator @load.__send__(v), :>=, 0
        assert_in_delta\
          4 * @load.__send__("#{v}_by_processor"),
          @load.__send__(v),
          1E-3
        assert_in_delta\
          2 * @load.__send__("#{v}_by_core"),
          @load.__send__(v),
          1E-3
      end
    end

    def test_load_array
      load_array = CPU.load.to_a
      assert_equal 3, load_array.size
      for v in load_array
        assert_kind_of Float, v
        assert_operator v, :>=, 0
      end
    end
  end
end

