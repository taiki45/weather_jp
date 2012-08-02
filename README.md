[![Build Status](https://secure.travis-ci.org/Taiki45/weather_jp.png?branch=master)](http://travis-ci.org/Taiki45/weather_jp)

## About

Fetch Japan weather info as Ruby object easily.

http://taiki45.github.com/weather_jp

## Installation

Add this line to your application's Gemfile:

    gem 'weather_jp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weather_jp

## Usage

```ruby
# creat weather object in differrnt ways
tokyo = WeatherJP::Weather.new :tokyo
minato = WeatherJp::Weather.new("東京都港区")

# get weather info as String
tokyo.get_weather(:today).to_s
  #=> can be "東京都 東京の天気は曇りのち晴れ、最高気温34度...etc"

# to get weather info at 4 day later now
minato.get_weather(4) #=> <#DayWeather object>
minato.get_weather(:today).forecast #=> can be "晴れ"
tokyo.today
minato.day_after_tomorrow

# use Weather object
tokyo.each do |w|
  puts w.city_name
  puts w.forecast
  puts w.max_temp
  w.each_pair {|k,v| puts k, v }
end

minato.map {|w| [w.day, w.forecast] }

# or use as simple Array or Hash
tokyo.to_a
minato.each {|w| p w.to_hash }

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
