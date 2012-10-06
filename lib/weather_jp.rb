# -*- coding:utf-8 -*-
require 'weather_jp/day_weather'
require 'weather_jp/version'
require 'uri'
require 'open-uri'
require 'rss'
require 'nokogiri'

module WeatherJp
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
      if day_and_city = parser(str)
        WeatherJp.get(day_and_city[:city]).get_weather(day_and_city[:day])
      end
    end

    def parser(str)
      if str =~ /((?<city>.*)の
          (?<day>今日|きょう|明日|あした|明後日|あさって|３日後|４日後|3日後|4日後)
          の(天気|てんき).*) |
          ((?<day>今日|きょう|明日|あした|明後日|あさって|３日後|４日後|3日後|4日後)の
          (?<city>.*)の(天気|てんき))
      /ux
        data = Regexp.last_match
        day = data[:day]
        case day
        when /今日|きょう/u
          day = 'today'
        when /明日|あした/u
          day = 'tomorrow'
        when /明後日|あさって/u
          day = 'day_after_tomorrow'
        when /3日後|３日後/u
          day = 3
        when /4日後|４日後/u
          day = 4
        else
          raise "No matched"
        end
        {day: day, city: data[:city]}
      else
        nil
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
        raise ArgumentError if @day_weathers[day] == nil
        @day_weathers[day]
      rescue
        raise ArgumentError,
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
        open(URI.encode("http://weather.service.msn.com/" +
          "find.aspx?outputview=search&weadegreetype=C&culture=ja-JP&" +
          "weasearchstr=#{city_name}")) do |xml|
          result = yield xml
        end
        result
      end

      def parse_xml(xml)
        doc = Nokogiri::XML(xml)
        begin 
          code =
            doc.xpath('//weather').attr('weatherlocationcode').value
          full_name = 
            doc.xpath('//weather').attr('weatherlocationname').value
        rescue
          raise ArgumentError,
            "invaild city name '#{city_name}'!"
        end
        [code.slice(3..-1), full_name]
      end

      def get_rss(area_code)
        begin
          uri = URI.parse(
            "http://weather.jp.msn.com/" +
            "RSS.aspx?wealocations=wc:#{area_code}&" +
            "weadegreetype=C&culture=ja-JP"
          )
          RSS::Parser.parse(uri, false)
        rescue
          raise StandardError,
            "the MSN weather sever may be downed, or got invaild city code"
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
            h[:max_temp] = i.slice(/(最高).*?(\d+)/u, 2)
            h[:min_temp] = i.slice(/(最低).*?(\d+)/u, 2)
            h[:rain] = i.slice(/(降水確率).*?(\d+)/u, 2)
            weathers << h
          end
          weathers
        rescue
          raise StandardError,
            "the MSN weather sever may be downed, or something wrong"
        end
      end
    end
  end
end
