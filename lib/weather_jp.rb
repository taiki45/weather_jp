# -*- coding:utf-8 -*-
require 'weather_jp/request_parser'
require 'weather_jp/weather'
require 'weather_jp/day_weather'
require 'weather_jp/wrapper'
require 'weather_jp/version'
require 'uri'
require 'open-uri'
require 'rss'
require 'nokogiri'

module WeatherJp
  class WeatherJpError < StandardError; end

  class << self
    def get(city_name, option = nil)
      if option
        Weather.new(city_name).get_weather(option)
      else
        Weather.new(city_name)
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
