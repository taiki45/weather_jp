# -*- coding:utf-8 -*-
require 'weather_jp/day_weather'
require 'weather_jp/version'
require 'uri'
require 'open-uri'
require 'rss'
require 'nokogiri'

module WeatherJp
  def self.get(city_name, option = nil)
    if option
      Weather.new(city_name).get_weather(option)
    else
      Weather.new(city_name)
    end
  end

  def self.customize_to_s(&code)
    Weather::DayWeather.class_eval do
      define_method(:to_s, &code)
    end
  end

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

    private
    def set_weathers
      begin
        weathers = Array.new
        get_weather_data.each do |i|
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
          data = remove_html_tag(str).split(/%/)
          data.pop
          data.map {|i| i.delete!('"') }
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

