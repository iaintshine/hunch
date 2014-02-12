require "rspec"
require "simplecov"

require "hunch"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
	config.order = "random"
end