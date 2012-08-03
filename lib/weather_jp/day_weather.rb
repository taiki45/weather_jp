# -*- coding:utf-8 -*-

module WeatherJp
  class Weather
    class DayWeather
      include Enumerable

      def initialize(weathers, city_name, day)
        @weather = weathers[day]
        @city_name = city_name
      end

      attr_reader :city_name

      def to_hash
        @weather
      end

      def each
        @weather.each {|_k, v| yield v }
      end

      def each_pair
        @weather.each_pair {|k,v| yield k, v }
      end

      def inspect
        word = "\#<DayWeather:@city_name = #{city_name}, "
        word << "@day=#{day}, @forecast=#{forecast}, "
        word << "@max_temp=#{max_temp}, @min_temp=#{min_temp}, "
        word << "@rain=#{rain}>"
        word
      end

      def to_s
        word = "#{city_name}の"
        word << "#{day}の天気は"
        word << "#{forecast} "
        word << "最高気温#{max_temp}度 " if max_temp
        word << "最低気温#{min_temp}度 " if min_temp
        word << "降水確率は#{rain}% " if rain
        word << "です。"
        word
      end

      def method_missing(key)
        @weather[key]
      end
    end
  end
end
