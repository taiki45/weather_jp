# -*- coding:utf-8 -*-
require 'weather_jp/request_parser'
require 'weather_jp/day_weather'
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
        WeatherJp.get(request.city).get_weather(request.day)
      end
    end
  end

  class Weather
    include Enumerable

    def initialize(city_name)
      @area_code, @city_name, @weathers = Wrapper.get(city_name)
      @day_weathers = Array.new(@weathers.size) do |n|
        DayWeather.new(@weathers,@city_name, n)
      end
    end

    attr_reader :city_name, :area_code, :day_weathers

    def to_hash
      @weathers
    end

    alias to_a to_hash

    def each
      @day_weathers.each do |i|
        yield i
      end
      self
    end

    def get_weather(day = 0)
      begin
        day = day.to_sym if day.class == String
        case day
        when :today
          day = 0
        when :tomorrow
          day = 1
        when :day_after_tomorrow
          day = 2
        end
        raise WeatherJpError if @day_weathers[day] == nil
        @day_weathers[day]
      rescue
        raise WeatherJpError,
          "unvaild argument '#{day}' for get_weather"
      end
    end

    %w(today tomorrow day_after_tomorrow).each do |s|
      define_method(s.to_sym) do
        get_weather(s)
      end
    end
  end

  module Wrapper
    class << self
      def get(city_name)
        area_code, city_name = get_area_code(city_name.to_s)
        weathers = set_weathers(parse_rss(get_rss(area_code)))
        [area_code, city_name, weathers]
      end

      def get_area_code(city_name)
        get_xml city_name do |xml|
          parse_xml xml
        end
      end

      def get_xml(city_name)
        result = []
        open(URI.encode('http://weather.service.msn.com/' +
          'find.aspx?outputview=search&weadegreetype=C&culture=ja-JP&' +
          "weasearchstr=#{city_name}")) do |xml|
          result = yield xml
        end
        result
      end

      def parse_xml(xml)
        doc = Nokogiri::XML(xml)
        begin
          code = doc.xpath('//weather').attr('weatherlocationcode').value
          full_name = doc.xpath('//weather').attr('weatherlocationname').value
        rescue
          raise WeatherJpError, 'Can not parse XML'
        end
        [code.slice(3..-1), full_name]
      end

      def get_rss(area_code)
        begin
          uri = URI.parse(
            'http://weather.jp.msn.com/' +
            "RSS.aspx?wealocations=wc:#{area_code}&" +
            'weadegreetype=C&culture=ja-JP'
          )
          RSS::Parser.parse(uri, false)
        rescue
          raise WeatherJpError,
            'the MSN weather sever may be downed, or got invaild city code'
        end
      end

      def parse_rss(rss)
        str = rss.channel.item(0).description
        data = remove_html_tag(str).split(/%/)
        data.pop
        data.map {|i| i.delete!('"') }
      end

      def remove_html_tag(str)
        str.gsub(/<(\"[^\"]*\"|'[^']*'|[^'\">])*>/,'""')
      end

      def set_weathers(raw_data)
        weathers = Array.new
        begin
          raw_data.each do |i|
            h = Hash.new
            h[:day] = i.slice(/(.*?):\s+(.*?)\./, 1)
            h[:forecast] = i.slice(/(.*?):\s+(.*?)\./, 2)
            h[:max_temp] = i.slice(/(最高).*?(-?\d+)/u, 2)
            h[:min_temp] = i.slice(/(最低).*?(-?\d+)/u, 2)
            h[:rain] = i.slice(/(降水確率).*?(\d+)/u, 2)
            [:max_temp, :min_temp, :rain].each do |j|
              h[j] = h[j].to_i if h[j]
            end
            if h[:day].match(/の天気/u)
              h[:day] = h[:day].slice(/(.*)の天気/u, 1)
            end
            weathers << h
          end
          weathers
        rescue NameError
          raise WeatherJpError,
            'the MSN weather sever may be downed, or something wrong'
        end
      end
    end
  end
end
