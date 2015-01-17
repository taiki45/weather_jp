module WeatherJp
  # @attr_reader [WeatherJp::City] city
  # @attr_reader [Array<WeatherJp::DayWeather>] weathers
  # @attr_reader [WeatherJp::DayWeather] current
  # @attr_reader [WeatherJp::DayWeather] today
  # @attr_reader [WeatherJp::DayWeather] tomorrow
  # @attr_reader [WeatherJp::DayWeather] day_after_tomorrow
  class Weather
    class << self
      private
      # Define extra readers
      def define_readers(*names)
        names.each {|s| define_method(s) { self.for(s) } }
      end
    end

    extend Forwardable
    include Enumerable

    define_readers :current, :today, :tomorrow, :day_after_tomorrow
    attr_reader :city, :weathers
    alias_method :day_weathers, :weathers
    alias_method :to_a, :weathers

    # @param [WeatherJp::City] city
    # @param [Array<WeatherJp::DayWeather>] weathers
    def initialize(city, weathers)
      @city = city
      @weathers = weathers
    end

    # @yield [WeatherJp::DayWeather]
    # @return [WeatherJp::Weather]
    def each(&block)
      each_with_all(&block)
    end

    # @yield [WeatherJp::DayWeather]
    # @return [WeatherJp::Weather]
    def each_with_all
      weathers.each {|i| yield i }
      self
    end

    # @yield [WeatherJp::DayWeather]
    # @return [WeatherJp::Weather]
    def each_without_current
      except_current.each {|i| yield i }
      self
    end

    # Except current weather status.
    # @return [Array<WeatherJp::DayWeather>]
    def except_current
      weathers.reject {|w| w.day_code == -1 }
    end

    # @param [String, Symbol] date
    # @return [WeatherJp::DayWeather, nil]
    def for(date)
      case date
      when Date
        raise NotImplemetedError
      when :current
        day = 0
      when :today
        day = 1
      when :tomorrow
        day = 2
      when :day_after_tomorrow
        day = 3
      end

      weathers[day]
    end

    # @deprecated Use {#for}
    alias_method :get_weather, :for

    # @deprecated This method will be removed.
    def to_hash
      @weathers
    end
  end
end
