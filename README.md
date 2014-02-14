# Hunch

Hunch is a rabbitmq client used for inter service communication inside our topware 
gaming platform. It is a broker/producer only gem. For a consumer please use hutch gem.

## Installation

Add this line to your application's Gemfile:

    gem "hunch", git: "http://192.168.100.16/servers/hunch.git"

And then execute:

    $ bundle

## Usage

```ruby
Hunch.configure do |c|
	c.logger = SemanticLogger[Hunch]
	# other custom initialization
end

Hunch.publish! "uaa.user_created", id: 1, username: "foobar", email: "foo@bar.com"

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
