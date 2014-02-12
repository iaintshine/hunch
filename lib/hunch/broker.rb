require "multi_json"
require "bunny"
require "securerandom"
require "hunch/configuration"
require "hunch/errors"

module Hunch
	class Broker
		attr_reader :connection, :config

		def initialize(config)
			@config = config

			connect!
		end

		def close
			@connection.close
			@connection = nil
		end

		def connected?
			@connection
		end

		def publish(routing_key, message, properties = {})
			payload = JSON.dump message

			attributes = properties.merge(non_overridable_properties)

			exchange.publish payload, attributes
		end

		def channel
			unless Thread.current[:channel]
				Thread.current[:channel] = connection.create_channel
			end
			Thread.current[:channel]
		end

		def exchange
			unless Thread.current[:exchange]
				Thread.current[:exchange] = channel.topic config.rabbitmq, durable: true
			end
			Thread.current[:exchange]
		end

	private

		def connect!
			@connection = Bunny.new host: config.rabbitmq[:host],
									port: config.rabbitmq[:port]
									username: config.rabbitmq[:username],
									password: config.rabbitmq[:pass],
									threaded: false
			
			@connection.start
		end

		def non_overridable_properties
			{
				persistent: 	true,
				routing_key: 	routing_key,
				timestamp: 		Time.now.to_i,
				content_type: 	"application/json",
				type: 			"kinda.bus",
				message_id: 	generate_message_id,
				app_id: 		config.app_id,
				headers: {
					request_id: config.request_id,
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