require 'test_helper'

class StrictSend < Test::Unit::TestCase
  def setup
    ScopedSend.strict!
  end

  def teardown
    ScopedSend.not_strict!
  end

  def test_strict_mode
    assert_raise(ScopedSend::Strict::Error, "Should not allow 'send'") { "hello world".send :to_s }
  end

  def test_temporary_override
    assert_equal 'hello world', ScopedSend.not_strict { "hello world".send :to_s }
  end
end
