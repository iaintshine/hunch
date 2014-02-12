require "hunch/version"
require "hunch/configuration"
require "hunch/broker"

module Hunch
	extend self

	def configure
		yield configuration
	end

	def configuration
		@configuration ||= Configuration.new
	end

	alias_method :config, :configuration

	def broker
		@broker ||= Broker.new configuration
	end

	def publish!(routing_key, message, attributes = {})
		broker.publish routing_key, message, attributes
	end
end

require "hunch/cli"
