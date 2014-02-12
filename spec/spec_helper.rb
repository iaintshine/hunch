require "rspec"
require "simplecov"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
	config.order = "random"
end