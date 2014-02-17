require "raven"
require "multi_json"
require "bunny"
require "securerandom"
require "thread_safe"

require "hunch/configuration"
require "hunch/errors"

module Hunch
	class Broker
		attr_reader :connection, :config, :channels, :exchanges

		def initialize(config)
			@config = config

			@channels 	= ThreadSafe::Array.new
			@exchanges 	= ThreadSafe::Array.new

			connect!
		end

		def close
			logger.info "disconnecting", host: uri

			close_exchanges!
			close_channels!

			@connection.close
			closed = @connection.status == :closed

			if closed 
				logger.info "disconnected", host: uri
				@connection = nil
			end

			closed
		end

		def connected?
			@connection && @connection.open?
		end

		def publish(routing_key, message, properties = {})
			logger.info "publishing message", routing_key: routing_key, message: message

			ensure_connection!

			payload = MultiJson.dump message

			attributes = properties.merge(non_overridable_properties(routing_key))

			logger.info "attributes: ", attributes
			logger.info "payload: ", payload

			statsd.batch do |batch|
				batch.increment "hunch.publish"
				batch.time("hunch.exchange_publish") { exchange.publish payload, attributes }
			end
		end

	private

		def logger
			@config.logger
		end 

		def statsd
			@config.statsd
		end

		def capture_exception(error_message, e)
			logger.error(error_message, e)
			Raven.capture_exception(e) if config.sentry?
			statsd.increment "hunch.exception"
		end

		def protocol
			config.rabbitmq[:tls] ? :amqps : :amqp
		end

		def vhost
			config.rabbitmq[:vhost].sub(/^\//, '')
		end

		def uri
			"%s://%s:%s@%s:%d/%s" % [protocol,
									config.rabbitmq[:user],
									config.rabbitmq[:pass],
									config.rabbitmq[:host],
									config.rabbitmq[:port],
									config.rabbitmq[:vhost]
									]
		end

		def with_connection_handler!(&block)
			yield if block_given?
		rescue Bunny::TCPConnectionFailed => e
			error_message = "could not connect to #{uri}"
			capture_exception(error_message, e)
			raise ConnectionError.new error_message
		rescue Bunny::PossibleAuthenticationFailureError => e
			error_message = "authentication failed for user #{config.rabbitmq[:user]}"
			capture_exception(error_message, e)
			raise ConnectionErorr.new error_message
		end

		def with_resource_handler!(type, &block)
			yield if block_given?
		rescue Bunny::PreconditionFailed => e
			error_message = "RabbitMQ responded with 406 Precondition Failed when creating this #{type}. " +
          					"Perhaps it is being redeclared with non-matching attributes. " + 
          					"Code: #{e.channel_close.reply_code}, message: #{e.channel_close.reply_text}"
			capture_exception(error_message, e)
			raise ChannelError.new(error_message)
		end

		def connect!
			logger.info "connecting to rabbitmq", host: uri

			@connection = Bunny.new connection_properties
			
			with_connection_handler! { @connection.start }
			
			@connection
		end

		def ensure_connection!
			raise_connection_error! unless @connection && @connection.open?
		end


		def create_channel!
			with_resource_handler! :channel do 
				ch = connection.create_channel  
				channels << ch
				ch
			end
		end

		def create_exchange!
			with_resource_handler! :exchange do
				exchg = channel.topic config.rabbitmq[:exchange], durable: true 
				exchanges << exchg
				exchg
			end
		end

		def close_exchanges!
			exchanges.clear
		end

		def close_channels!
			channels.each do |ch|
			 	begin
			 		ch.close
			 	rescue Bunny::NotFound => e
			 		error_message = "Failed to close a channel. " + 
			 						"Code: #{e.channel_close.reply_code}, message: #{e.channel_close.reply_text}"
			 		capture_exception error_message, e
			 		raise ChannelError.new error_message
			 	end 
			end
			channels.clear
		end

		def channel
			unless Thread.current[:channel]
				Thread.current[:channel] = create_channel!
			end
			Thread.current[:channel]
		end

		def exchange
			unless Thread.current[:exchange]
				Thread.current[:exchange] = create_exchange!
			end
			Thread.current[:exchange]
		end

		def connection_properties
			{
				host: 						config.rabbitmq[:host],
				port: 						config.rabbitmq[:port],
				username: 					config.rabbitmq[:username],
				password: 					config.rabbitmq[:pass],
				vhost: 						config.rabbitmq[:vhost],
				threaded: 					false,
				automatically_recover: 		true,
				network_recovery_interval: 	1,
				logger: 					SemanticLogger[Bunny]
			}
		end

		def non_overridable_properties(routing_key)
			{
				persistent: 	true,
				routing_key: 	routing_key,
				timestamp: 		Time.now.to_i,
				content_type: 	"application/json",
				type: 			"kinda.bus",
				message_id: 	generate_message_id,
				app_id: 		config.app_id,
				headers: {
					request_id: config.request_id.call,
					hostname: 	config.host,
					pid: 		Process.pid 
				}
			}
		end

		def generate_message_id
			SecureRandom.uuid
		end

	end
end