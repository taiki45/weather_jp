module WeatherJp
  class City < Struct.new(:name, :area_code)
    alias_method :to_s, :name
  end
end
