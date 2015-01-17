#!/usr/bin/env rake
require "bundler"
Bundler::GemHelper.install_tasks
#
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ["-c", "-fd"]
end

task :default => :spec
task :test => :spec
