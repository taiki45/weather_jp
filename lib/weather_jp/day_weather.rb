module WeatherJp
  # @attr_reader [WeatherJp::City] city
  # @attr_reader [Integer] date_code Current is 0, today is 1, tomorrow is 2
  class DayWeather
    extend Forwardable

    # Canonical key names for attributes.
    KEYS = %i(text high low rain date date_text date_code city_name city)

    attr_reader :city, :date_code

    # @param [Hash] attrs
    # @param [WeatherJp::City] city
    # @param [Integer] date_code
    def initialize(attrs, city, date_code)
      @attrs = attrs
      @city = city
      @date_code = date_code
    end

    # @return [String]
    def city_name
      city.name
    end

    # Sky status. i.e. 'sunny' or '晴れ'.
    # @return [String]
    def text
      @attrs['skytext'] || @attrs['skytextday']
    end

    # @return [Integer, nil]
    def high
      get('high').try(:to_i)
    end

    # @return [Integer, nil]
    def low
      get('low').try(:to_i)
    end

    # @return [Integer, nil]
    def precip
      get('precip').try(:to_i)
    end

    # Only available for current weather.
    # @return [Integer, nil]
    def temperature
      get('temperature').try(:to_i)
    end

    # Only available for current weather.
    # @return [Integer, nil]
    def wind_speed
      get('windspeed').try(:to_i)
    end

    # Only available for current weather.
    # i.e. '風向: 北北西 / 風速: 20 マイル'
    # @return [String, nil]
    def wind_text
      get('winddisplay')
    end

    # @return [Date, nil]
    def date
      raw_date ? Date.parse(raw_date) : nil
    end

    # Japanese date text from current day.
    # @return [String, nil]
    def date_text
      case date_code
      when -1
        "今"
      when 0
        "今日"
      when 1
        "明日"
      when 2
        "明後日"
      else
        "#{date_code}日後"
      end
    end

    # @return [String]
    def to_s
      word ="#{date_text}の"
      word << "#{city_name}の天気は"
      word << "#{text}"
      word << ", 最高気温#{high}度" if high
      word << ", 最低気温#{low}度" if low
      word << ", 降水確率は#{precip}%" if precip
      word << "です。"
      word
    end

    # Same as {Hash#each}
    def_delegators :each, :to_hash

    # @return [Hash]
    def to_hash
      h = Hash[KEYS.map {|k| [k, public_send(k)] }]
      h[:city] = h[:city].to_hash
      h
    end

    # @deprecated Use {#high}
    alias_method :max_temp, :high

    # @deprecated Use {#low}
    alias_method :min_temp, :low

    # @deprecated Use {#text}
    alias_method :forecast, :text

    # @deprecated Use {#date_text}
    alias_method :day, :date_text

    # @deprecated Use {#precip}
    alias_method :rain, :precip

    private

    # Convert empty string to nil
    def get(key)
      @attrs[key].present? ? @attrs[key] : nil
    end

    # @return [String]
    def raw_date
      get('date')
    end
  end
end
