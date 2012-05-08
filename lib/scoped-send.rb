module ScopedSend
end

require 'scoped_send/object_extension'
require 'scoped_send/strict'

ScopedSend.extend ScopedSend::Strict

class Object
  include ScopedSend::ObjectExtension
end
