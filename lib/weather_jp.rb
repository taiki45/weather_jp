# -*- coding:utf-8 -*-
require 'weather_jp/day_weather'
require 'weather_jp/version'
require 'uri'
require 'open-uri'
require 'rss'
require 'nokogiri'

module WeatherJp
  class Weather
    include Enumerable

    def initialize(city_name)
      city_name = city_name.to_s if city_name.class == Symbol
      @area_code, @city_name = get_area_code(city_name)
      @weathers = set_weathers
      @day_weathers = Array.new(@weathers.size) do |n| 
        DayWeather.new(@weathers,@city_name, n)
      end
    end

    attr_reader :city_name, :area_code, :day_weathers

    public
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
        end
        raise ArgumentError if @day_weathers[day] == nil
        @day_weathers[day]
      rescue
        raise ArgumentError,
          "unvaild argument '#{day}' for get_weather"
      end
    end

    private
    def set_weathers
      begin
        data = get_weather_data
        data.pop
        weathers = Array.new
        data.each do |words|
          weather = Hash.new
          words.delete!('"')
          weather[:day] = words.slice!(/(.*?):/).delete(':')
          weather[:forecast] = 
            words.slice!(/\s(.*?)\./).delete('.').delete(" ")
          weather[:max_temp] = 
            words.slice!(/(.*?)\.|\:/).slice(/(\d+)/)
          weather[:rain] = words.slice(/(\d+)/)
          weathers << weather
        end
        weathers
      rescue
        raise StandardError,
          "the MSN weather sever may be downed, or something wrong"
      end
    end

    def get_area_code(city_name)
      uri = URI.encode(
        "http://weather.service.msn.com/" + \
        "find.aspx?outputview=search&weadegreetype=C&culture=ja-JP&" + \
        "weasearchstr=#{city_name}")
        doc = Nokogiri::XML(open(uri))
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


    def get_weather_data
      begin
        uri = URI.parse(
          "http://weather.jp.msn.com/" + \
          "RSS.aspx?wealocations=wc:#{@area_code}&" + \
          "weadegreetype=C&culture=ja-JP")
          rss = RSS::Parser.parse(uri, false)
          str = rss.channel.item(0).description
          remove_html_tag(str).split(/%/)
      rescue
        raise StandardError,
          "the MSN weather sever may be downed, or got invaild city code"
      end
    end

    def remove_html_tag(string)
      string.gsub!(/<(\"[^\"]*\"|'[^']*'|[^'\">])*>/,'""')
    end
  end
end

