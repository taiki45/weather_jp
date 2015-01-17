require 'uri'
require 'open-uri'
require 'rss'
require 'nokogiri'

require 'weather_jp/request_parser'
require 'weather_jp/weather'
require 'weather_jp/day_weather'
require 'weather_jp/wrapper'
require 'weather_jp/version'

module WeatherJp
  class WeatherJpError < StandardError; end

  class << self
    def get(city_name, option = nil)
      area_code, city_name, weathers = Wrapper.get(city_name)
      weather = Weather.new(area_code, city_name, weathers)

      if option
        weather.get_weather(option)
      else
        weather
      end
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
