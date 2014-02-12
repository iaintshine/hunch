require "hunch/configuration"

describe Hunch::Configuration do
	describe ".sentry?" do 
		
		context "with default options" do 
			let(:conf) { Hunch::Configuration.new }
			it { expect(conf.sentry?).to be_false }
		end

		context "with sentry enabled" do 
			let(:conf) { Hunch::Configuration.new(sentry: true) }
			it { expect(conf.sentry?).to be_true }
		end

	end

	describe ".logger" do

		context "with default options" do 
			let(:conf){ Hunch::Configuration.new }
			it { expect(conf.logger).not_to be_nil }
			it { expect(conf.logger).to be_instance_of(Logger) }
		end

		context "for nil logger" do 
			let(:conf) { Hunch::Configuration.new }
			it { expect(conf.logger).not_to be_nil }
			it { expect(conf.logger).to be_instance_of(Logger) }
		end
	end

	describe ".rabbitmq" do 

		context "with default options" do 
			let(:conf) { Hunch::Configuration.new }
			it { expect(conf.rabbitmq).to eq(Hunch::Configuration::DEFAULT_RABBITMQ) }
		end

		context "for custom rabbitmq" do 
			let(:host) { "utility.topware.com" }
			let(:conf) { Hunch::Configuration.new(rabbitmq: { host: host}) }
			it { expect(conf.rabbitmq[:host]).to eq(host) }
		end

		context "for invalid rabbitmq" do 
			let(:conf) { Hunch::Configuration.new(rabbitmq: { host: nil }) }
			it { expect { conf }.to raise_error(ArgumentError) }
		end

	end

end