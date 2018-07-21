require 'test_helper'
require 'cpu'

module CPU
  class LoadTest < Minitest::Test
    def test_load_minutes
      CPU.stub :num_processors, 4 do
        CPU.stub :num_cores, 2 do
          @load = CPU.load
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

