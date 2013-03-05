require_relative '../../test_helper'

class TestConfig < MiniTest::Unit::TestCase

  def test_class_defaults
    assert_equal( false, SendWithUs::Config.defaults.empty? )
    assert_equal( 'https', SendWithUs::Config.defaults[:protocol] )
  end

  def test_config_unmerged
    assert_equal( 'https', SendWithUs::Config.new.protocol )
    assert_equal( true, SendWithUs::Config.new.respond_to?(:protocol) )
    assert_raises( NoMethodError ) { SendWithUs::Config.new.widget }
  end

  def test_config_merged
    assert_equal( 'proto', SendWithUs::Config.new({ protocol: 'proto'}).protocol )
    assert_equal( true, SendWithUs::Config.new.respond_to?(:protocol) )
    assert_raises( NoMethodError ) { SendWithUs::Config.new({ protocol: 'proto'}).widget }
  end

end
