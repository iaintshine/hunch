require "statsd"

module Hunch
	class NullStatsd
		def increment(stat, sample_rate=1); 	end
    	def decrement(stat, sample_rate=1); 	end
		def count(stat, count, sample_rate=1); 	end
		def gauge(stat, value, sample_rate=1); 	end
		def set(stat, value, sample_rate=1); 	end
		def timing(stat, ms, sample_rate=1); 	end
		def time(stat, sample_rate=1); yield 	end
		def batch(&block); yield self 			end
	end
end