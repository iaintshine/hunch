require "semantic_logger"
require "hunch/null_statsd"
require "yaml"

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
            @request_id = options[:request_id] || -> { Thread.current[:request_id] || "<unknown>" }

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

        def load_from_file(filename)
            root = File.expand_path('../../../', __FILE__)
            hunchrc = File.join(root, filename)

            return logger.warn "#{filename} not found" unless File.exist? hunchrc
            config = YAML::load_file hunchrc

            config.each { |k, v| @rabbitmq[k.to_sym] = v }
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

            raise ArgumentError, "logger option should be an instance of SemanticLogger::Logger" unless @logger.kind_of?(SemanticLogger::Logger)
            raise ArgumentError, "statsd option should be an instance of Statsd" unless @statsd.is_a?(Statsd) || @statsd.is_a?(NullStatsd)
            raise ArgumentError, "request_id option should be a proc" unless @request_id.respond_to?(:call)
        end
    end
end
