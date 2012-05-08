require 'test_helper'

class SendTest < Test::Unit::TestCase
  module Mod
    def mod; "mod" end
  end

  class Basic
    def foo; "foo" end
  end

  class Inherited < Basic
    def bar; "bar" end
  end

  class WithModule
    include Mod
  end

  class InheritedWithModule < WithModule
  end

  module ForeignMod
    def mod; 'foreign mod' end
  end

  class ScopedMethodMissing < Basic
    include Mod

    def scoped_method_missing(scopes, name, *args, &blk)
      [ scopes, name, *args, blk ]
    end
  end

  def test_scope_by_name
    assert_equal 'bar', Inherited.new.scoped_send([ 'foo', 'bar' ], 'bar')
    assert_equal 'mod', WithModule.new.scoped_send([ 'mod' ], 'mod')

    assert_raise(NoMethodError) { Inherited.new.scoped_send([ 'foo', 'bar' ], 'to_s') }
  end

  def test_scope_by_symbol_name
    assert_equal 'foo', Basic.new.scoped_send([ :foo ], :foo)
    assert_equal 'foo', Basic.new.scoped_send([ :foo ], 'foo')
    assert_equal 'foo', Basic.new.scoped_send([ 'foo' ], :foo)
  end

  def test_scope_by_module
    assert_equal 'bar', Inherited.new.scoped_send([ Inherited ], 'bar')
    assert_equal 'mod', WithModule.new.scoped_send([ Mod ], 'mod')
    assert_raise(NoMethodError) { Inherited.new.scoped_send([ Inherited ], 'foo') }

    assert_raise(NoMethodError, "Should require the object to be instance of the module") do
      WithModule.new.scoped_send([ ForeignMod ], 'mod')
    end
  end

  def test_scoped_method_missing
    (scopes, name, *args, blk) = ScopedMethodMissing.new.scoped_send([ :bar, Mod ], :foo, 'arg1', 'arg2') { 'block' }

    assert_equal [:bar, Mod], scopes, "Should not alter the scopes"
    assert_equal :foo, name
    assert_equal [ 'arg1', 'arg2' ], args
    assert_equal 'block', blk.call
  end
end
