require 'rack/utils'

module WeatherJp
  class Adapter
    class << self
      # Returns nil when not found weather forecasts.
      # @param [String] city_name
      # @return [WeatherJp::Weather, nil]
      def get(city_name)
        new(city_name).get
      end
    end

    BASE_URL = 'http://weather.service.msn.com/'
    ACTION = 'data.aspx'
    LANG = 'ja-JP'
    SCALE = 'C'

    attr_reader :name

    def initialize(city_name)
      @name = city_name
    end

    def get
      weather_node ? weather : nil
    end

    def build_weather(attrs, day_weathers)
    end

    def weather
      Weather.new(city, day_weathers)
    end

    def day_weathers
      day_weather_nodes.each_with_index.map do |n, i|
        attrs = n.respond_to?(:to_h) ? n.to_h : n.values
        DayWeather.new(attrs, city, i - 1)
      end
    end

    def day_weather_nodes
      xml.xpath('/weatherdata/weather/*[attribute::skytextday or attribute::skytext]')
    end

    def city
      @city ||= begin
        attrs = weather_node.respond_to?(:to_h) ? weather_node.to_h : weather_node.values
        City.new(attrs['weathercityname'], attrs)
      end
    end

    def weather_node
       @weather_node ||= xml.xpath('/weatherdata/weather').first
    end

    def xml
      @xml ||= Nokogiri::XML.parse(xml_str)
    end

    def xml_str
      @xml_str ||= Reader.read(url)
    end

    def url
      "#{BASE_URL}#{ACTION}?#{Rack::Utils.build_query(params)}"
    end

    def params
      {
        weadegreetype: SCALE,
        culture: LANG,
        weasearchstr: name,
      }
    end

    module Reader
      class << self
        def read(url)
          open(url).read
        rescue OpenURI::HTTPError => e
          raise ServiceUnavailable.new("status=#{e.message[0..-2]}")
        end
      end
    end
  end
end
