$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'apiserver/version'


Gem::Specification.new do |s|
  s.name          = 'apiserver'
  s.version       = APIServer::Version
  s.authors       = ['Ken J.']
  s.email         = ['kenjij@gmail.com']
  s.summary       = %q{A Sinatra based API server template}
  s.description   = %q{Template of a Sinatra based HTTP API server.}
  s.homepage      = 'https://github.com/kenjij/sinatra-server-template'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'kajiki', '~> 1.1'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
end
