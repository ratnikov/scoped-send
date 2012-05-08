module ScopedSend
  module ObjectExtension
    def scoped_send(scopes, name, *args, &blk)
      if method_in_scope?(scopes, name)
        send(name, *args, &blk)
      else
        scoped_method_missing(scopes, name, *args, &blk)
      end
    end

    def method_in_scope?(scopes, name)
      scopes.inject([]) do |acc, name_or_module|
        if name_or_module.respond_to?(:public_instance_methods)
          name_or_module === self ? acc.push(*name_or_module.public_instance_methods(false)) : acc
        else
          acc.push name_or_module.to_sym
        end
      end.include?(name.to_sym)
    end

    def scoped_method_missing(scopes, name, *args, &blk)
      raise NoMethodError, "method #{name.inspect} is not in scope"
    end
  end
end
