require "hunch/configuration"

describe Hunch::Configuration do

    describe "#sentry?" do

        context "with default options" do
            let(:conf) { Hunch::Configuration.new }
            it { expect(conf.sentry?).to be_false }
        end

        context "with sentry enabled" do
            let(:conf) { Hunch::Configuration.new(sentry: true) }
            it { expect(conf.sentry?).to be_true }
        end

    end

    describe "#logger" do

        context "with default options" do
            let(:conf){ Hunch::Configuration.new }
            it { expect(conf.logger).not_to be_nil }
            it { expect(conf.logger).to be_instance_of(SemanticLogger::Logger) }
        end

        context "for nil logger" do
            let(:conf) { Hunch::Configuration.new }
            it { expect(conf.logger).not_to be_nil }
            it { expect(conf.logger).to be_instance_of(SemanticLogger::Logger) }
        end

        context "for invalid logger" do
            let(:conf) { Hunch::Configuration.new(logger: $stdout) }
            it { expect { conf }.to raise_error(ArgumentError) }
        end
    end

    describe "#statsd" do

        context "with default options" do
            let(:conf) { Hunch::Configuration.new }
            it { expect(conf.statsd).to be_instance_of(Hunch::NullStatsd) }
        end

        context "for nil statsd" do
            let(:conf) { Hunch::Configuration.new statsd: nil }
            it { expect(conf.statsd).to be_instance_of(Hunch::NullStatsd) }
        end

        context "for invalid instance" do
            let(:conf) { Hunch::Configuration.new statsd: "statsd" }
            it { expect{ conf.statsd }.to raise_error(ArgumentError) }
        end
    end

    describe "#app_id" do

        context "with default options" do
            let(:conf) { Hunch::Configuration.new }
            it { expect(conf.app_id).to eq(Hunch::Configuration::APP_UNDEFINED) }
        end

        context "for custom id" do
            let(:app_id) { "uaa" }
            let(:conf) { Hunch::Configuration.new app_id: app_id }
            it { expect(conf.app_id).to eq(app_id) }
        end

    end

    describe "#request_id" do

        context "with default options" do
            let(:conf) { Hunch::Configuration.new }
            it { expect(conf.request_id).not_to be_nil }
            it { expect(conf.request_id).to respond_to(:call) }
        end

        context "for invalid type" do
            let(:conf) { Hunch::Configuration.new request_id: "AABBCC-DDEE-FFGG-HHII" }
            it { expect{ conf.request_id }.to raise_error(ArgumentError) }
        end

    end

    describe "#rabbitmq" do

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
