require "semantic_logger"
require "hunch/null_statsd"

module Hunch
	class Configuration
		HOST_UNKNOWN   = '<host-unknown>'.freeze
		APP_UNDEFINED  = '<app-undefined>'.freeze

		attr_accessor :rabbitmq
		attr_accessor :logger
		attr_accessor :sentry
		attr_accessor :statsd
		attr_accessor :host
		attr_accessor :app_id
		attr_accessor :request_id

		alias :app=, :app_id=

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
			@statsd   = options[:statsd] || NullStatsd.new
			@host     = options[:host]	 || query_host
			@app_id   = options[:app_id] || options[:app] || query_app
			@request_id = options[:request_id] || -> { Thread.current[:request_id] }

			sanitize!
		end

		def sentry?
			@sentry
		end

		def host_known?
			@host != HOST_UNKNOWN
		end

		def app_known?
			@app_id != APP_UNDEFINED
		end

	private

		def default_logger
			SemanticLogger[Hunch]
		end

		def query_host
			`hostname -s`.chomp || HOST_UNKNOWN
		end

		def query_app
			APP_UNDEFINED
		end

		def sanitize!
			MANDATORY_RABBIT_OPTIONS.each do |opt|
				raise ArgumentError, "[:rabbitmq][:#{opt}] option is missing" unless @rabbitmq[opt]
			end
		end
	end
end