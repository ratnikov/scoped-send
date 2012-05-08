$:.push File.expand_path('../lib', __FILE__)
require 'scoped_send/version'

Gem::Specification.new do |s|
  s.name = 'scoped_send'
  s.version  = ScopedSend::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = [ 'Dmitry Ratnikov' ]
  s.email = [ 'ratnikov@google.com' ]
  s.homepage = 'http://github.com/ratnikov/scoped-send'
  s.summary = 'Adds Object#scoped_send method to explicitly define scope for which send is executed'

  s.files = Dir[ 'lib/**/*' ]
  s.require_paths = [ 'lib' ]
end
