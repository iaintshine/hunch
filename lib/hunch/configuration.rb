module Hunch
	class Configuration
		attr_accessor :rabbitmq
		attr_accessor :logger
		attr_accessor :sentry

		DEFAULT_RABBITMQ = { 
			host: 		'localhost',
			port: 		5672,
			user: 		'guest',
			pass: 		'guest',
			exchange: 	'hutch',
			vhost: 		'/',
			tls: 		false,
			tls_cert: 	nil,
			tls_pass:	nil		
		}.freeze

		def initialize(options = {})
			@rabbitmq = DEFAULT_RABBITMQ.merge(options[:rabbitmq])
			@logger   = options[:logger] || default_logger
			@sentry   = options[:sentry] || options[:raven]
		end

		def sentry?
			@sentry
		end

	private

		def default_logger
			::Logger.new(STDOUT)
		end
	end
end