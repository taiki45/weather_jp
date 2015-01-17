module WeatherJp
  # @attr_reader [String] name
  class City
    # Canonical key names for attributes.
    KEYS = %i(name full_name code latitude longitude)

    attr_reader :name

    # @param [String] name
    # @param [Hash] attrs
    def initialize(name, attrs = {})
      @name = name
      @attrs = attrs
    end

    # @return [String]
    def full_name
      @attrs['weatherlocationname']
    end

    # i.e. 'JAXX0085'
    # @return [String]
    def code
      if str = @attrs['weatherlocationcode']
        str.split(':').last
      else
        nil
      end
    end
    alias_method :area_code, :code
    alias_method :location_code, :code

    # @return [Float]
    def latitude
      @attrs['lat'].try(:to_f)
    end
    alias_method :lat, :latitude

    # @return [Float]
    def longitude
      @attrs['long'].try(:to_f)
    end
    alias_method :long, :longitude

    alias_method :to_s, :name

    # @return [Hash]
    def to_hash
      Hash[KEYS.map {|k| [k, public_send(k)] }]
    end
  end
end
