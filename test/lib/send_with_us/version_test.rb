require_relative '../../test_helper'

class TestVersion < MiniTest::Unit::TestCase

  def test_version
    assert_equal( false, SendWithUs::VERSION.nil? )
  end

end
