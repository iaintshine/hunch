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

# communication with post office service
Hunch.publish! "email.welcome", template_id: "welcome", to: "boguslaw.mista@realitypump.com",
				 data: { name: "iaintshine" }
```

## CLI

One can use debug console for testing. 

1. Copy the `.hunch.example` to `.hunch`, fill all the missing parts.
2. Call `bin/hunch console` to start up console with configured environment. 
3. Now to publish a message just call the `Hunch::publish!` method with routing key 
and message set as usage section shows.

## CLI commands

* `hunch console` - start a console with hunch environment configured. `.hunch` rc file is used for configuration if found. 
* `hunch publish` - publish a message to the rabbitmq. `.hunch` rc file is used for configuration if found. Options:
	* `-k`, *required*, string, routing key, eg. `-k=uaa.user_created`
	* `-m`, *required*, hash, message hash, eg. `-m=username:foobar`  
	* `-p`, *optional*, hash, additional exchange properties

For more info `bin/hunch help` or `bin/hunch help [COMMAND]`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
