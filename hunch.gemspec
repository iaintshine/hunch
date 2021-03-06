# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hunch/version'

Gem::Specification.new do |spec|
  spec.name          = "hunch"
  spec.version       = Hunch::VERSION
  spec.authors       = ["iaintshine"]
  spec.email         = ["bodziomista@gmail.com"]
  spec.description   = %q{rabbitmq client used for inter service communication}
  spec.summary       = %q{Hunch is a rabbitmq client used for inter service communication. 
                          Its a broker/producer only gem. For a consumer use 
                          original hutch library.}
  spec.homepage      = "https://github.com/iaintshine/hunch"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bunny", "~> 1.1.0"
  spec.add_runtime_dependency "multi_json", "~> 1.0"
  spec.add_runtime_dependency "thread_safe", "~> 0.1.3"
  spec.add_runtime_dependency "semantic_logger", "~> 2.6.1"
  spec.add_runtime_dependency "sentry-raven", "~> 0.7.1"
  spec.add_runtime_dependency "statsd-ruby", "~> 1.2.1"
  spec.add_runtime_dependency "thor", "~> 0.18.1"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
