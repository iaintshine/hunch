require 'thor'

module Hunch
    class CLI < Thor
        include Thor::Actions

        desc "console", "start a console with hunch. .hunch rc file is used for configuration if found."
        def console
            system "irb -I bin -r irbrc.rb"
        end

        desc "publish", "publish a message to the rabbitmq. .hunch rc file is used for configuration if found."
        method_option :routing_key, type: :string, 	aliases: "-k", required: true
        method_option :message, 	type: :hash, 	aliases: "-m", required: true
        method_option :properties, 	type: :hash, 	aliases: "-p", required: false, default: {}
        def publish
            load_hunchrc

            Hunch.publish! options[:routing_key], options[:message], options[:properties]
        end

    private

        def load_hunchrc
            Hunch.configuration.load_from_file ".hunch"
        end

    end
end
