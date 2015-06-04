require_relative '../../test_helper'

class TestVersion < Minitest::Test

  def test_version
    assert_equal( false, SendWithUs::VERSION.nil? )
  end

end
