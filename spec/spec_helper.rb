require 'webmock/rspec'
require 'pry'

# Use RSpec context
module Fixturable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def set_fixture(name)
      before do
        allow(WeatherJp::Adapter::Reader).to receive(:read).
          and_return(fixture_for(name))
      end
    end
  end

  # @return [String]
  def fixture_for(name)
    File.open(File.join(fixture_path, name)).read
  end

  def fixture_path
    File.expand_path(File.join('..', 'fixture'), __FILE__)
  end
end

require 'simplecov'
require 'coveralls'

Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec'
end

$:.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)
require 'weather_jp'
