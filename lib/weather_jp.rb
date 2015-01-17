require 'forwardable'
require 'nokogiri'
require 'open-uri'
require 'uri'

require 'active_support'
require 'active_support/core_ext/object'
require 'rack'

require 'weather_jp/city'
require 'weather_jp/weather'
require 'weather_jp/day_weather'
require 'weather_jp/adapter'
require 'weather_jp/request_parser'
require 'weather_jp/version'

module WeatherJp
  class WeatherJpError < StandardError; end
  class ServiceUnavailable < WeatherJpError; end

  class << self
    # @param [String] city_name
    # @return [WeatherJp::Weather, nil]
    def get(city_name)
      Adapter.get(city_name)
    end

    # Request like '明日の東京の天気教えて'.
    # @param [String] query
    # @return [WeatherJp::Weather, nil]
    def parse(query)
      if request = RequestParser.parser(query)
        get(request.city).get_weather(request.day)
      end
    end
  end
end
