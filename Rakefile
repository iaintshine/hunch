#!/usr/bin/env rake
require "bundler/gem_tasks"

# Rspec 
# =================================
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |task|
	task.pattern = "spec/**/*_spec.rb"
end

task default: :spec


# Rspec 
# =================================
require_relative "lib/hunch/version"

namespace :package do
    NAME = "hunch"
    VER  = Hunch::VERSION

    task :build do
        sh "gem build #{NAME}.gemspec"
    end

    task :publish do 
        sh "gem push ./#{NAME}-#{VER}.gem"
    end
end