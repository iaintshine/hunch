#!/usr/bin/env ruby

module Hunch
	class Cli
		class << self
			def start(*args)
				system "irb -r ./lib/hunch.rb"
			end
		end
	end
end