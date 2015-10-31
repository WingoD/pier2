require 'minitest_helper'

class TestPier2 < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pier2::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end
