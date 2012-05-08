module ScopedSend
  module Strict
    class Error < StandardError; end

    def strict!
      @strict = true
    end
    
    def not_strict!
      @strict = false
    end

    def strict?
      !!@strict
    end

    def not_strict
      old, @strict = strict?, false

      yield
    ensure
      @strict = old
    end
  end
end

class Object
  def send(*args, &blk)
    raise ScopedSend::Strict::Error, "Attempted to invoke 'send' while in strict mode" if ScopedSend.strict?

    super
  end
end
