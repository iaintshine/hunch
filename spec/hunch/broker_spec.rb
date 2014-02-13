require "hunch/configuration"
require "hunch/broker"

describe Hunch::Broker do 
	let(:config){ Hunch::Configuration.new }
	let(:broker){ Hunch::Broker.new config }

	describe "#connect" do
	end

	describe "#connected?" do 
	end

	describe "#close" do 
	end

	describe "#publish" do 
	end
end