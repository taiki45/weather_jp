require 'uri'
require 'open-uri'
require 'nokogiri'
require 'forwardable'
require 'rack'
require 'active_support/core_ext/object'

require 'weather_jp/city'
require 'weather_jp/weather'
require 'weather_jp/day_weather'
require 'weather_jp/wrapper'
require 'weather_jp/request_parser'
require 'weather_jp/version'

module WeatherJp
  class WeatherJpError < StandardError; end
  class ServiceUnavailable < WeatherJpError; end

  class << self
    # @param [String] city_name
    # @return [WeatherJp::Weather]
    def get(city_name)
      Wrapper.new(city_name).get
    end

    def customize_to_s(&code)
      Weather::DayWeather.class_eval do
        define_method(:to_s, &code)
      end
    end

    def parse(str)
      if request = RequestParser.parser(str)
        get(request.city).get_weather(request.day)
      end
    end
  end
end
