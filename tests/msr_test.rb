require 'test/unit'
require 'msr'

class MSRTest < Test::Unit::TestCase
  def setup
    @cpu0, @cpu1 = MSR.sort_by { |c| c.cpuid }
  end

  def test_loaded
    assert MSR.loaded?
  end

  def test_instance
    assert_kind_of MSR::CPU, @cpu0
    assert_equal 0, @cpu0.cpuid
    assert_kind_of MSR::CPU, @cpu1
    assert_equal 1, @cpu1.cpuid
  end

  def test_temperature
    assert_operator @cpu0.temperature, '>', 0
    assert_operator @cpu1.temperature, '>', 0
  end
end
