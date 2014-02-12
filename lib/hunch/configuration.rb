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

		MANDATORY_RABBIT_OPTIONS = [:host, :port, :user, :pass]

		def initialize(options = {})
			@rabbitmq = DEFAULT_RABBITMQ.merge(options[:rabbitmq] || {})
			@logger   = options[:logger] || default_logger
			@sentry   = options[:sentry] || options[:raven] || false

			sanitize!
		end

		def sentry?
			@sentry
		end

	private

		def default_logger
			::Logger.new(STDOUT)
		end

		def sanitize!
			MANDATORY_RABBIT_OPTIONS.each do |opt|
				raise ArgumentError, "[:rabbitmq][:#{opt}] option is missing" unless @rabbitmq[opt]
			end
		end
	end
end