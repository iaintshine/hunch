# Hunch

Hunch is a rabbitmq client used for inter service communication. It is a broker/producer only gem. For a consumer please use hutch gem.

## Installation

Add this line to your application's Gemfile:

    gem "hunch", :git => "https://github.com/iaintshine/hunch.git"

And then execute:

    $ bundle

## Usage

### Configure 

```ruby
Hunch.configure do |c|
	c.logger = SemanticLogger[Hunch] # optional
	c.app    = "users_service"       # optional, deafult: "<app-undefined>" 
    c.host   = "users-host01"        # optional default: `hostname -s`
    c.request_id = -> { Thread.current[:request_id ] } # optional, default: "<unknown>"
    c.sentry     = sentry_instance   # optional
    c.statsd     = statsd_instance   # optional
end
```

### Publish

```ruby
Hunch.publish! "user.new", id: 1, username: "foobar", email: "foo@bar.com"
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
