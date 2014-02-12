require "hunch/version"
require "hunch/configuration"

module Hunch
	extend << self

	def configure
		yield configuration
	end

	def configuration
		@configuration ||= Configuration.new
	end

	alias_method :config, :configuration
end

require "hunch/cli"
require ""
