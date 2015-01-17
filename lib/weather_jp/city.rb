module WeatherJp
  class City
    attr_reader :name

    def initialize(name, attrs = {})
      @name = name
      @attrs = attrs
    end

    def full_name
      @attrs['weatherlocationname']
    end

    def code
      @attrs['weatherlocationcode']
    end
    alias_method :area_code, :code
    alias_method :location_code, :code

    def lat
      @attrs['lat']
    end

    def long
      @attrs['long']
    end

    alias_method :to_s, :name
  end
end
