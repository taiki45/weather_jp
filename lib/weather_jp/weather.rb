module WeatherJp
  class Weather
    extend Forwardable
    include Enumerable

    attr_reader :city, :day_weathers
    def_delegators :city, :name, :area_code

    def initialize(city, weathers)
      @city = city
      @weathers = weathers

      @day_weathers = Array.new(@weathers.size) do |n|
        DayWeather.new(@weathers, city.name, n)
      end
    end

    def to_hash
      @weathers
    end

    # TODO
    alias to_a to_hash

    def each
      @day_weathers.each do |i|
        yield i
      end
      self
    end

    # TODO: remove number acceptance
    # @param [String, Symbol, Integer] day
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
end
