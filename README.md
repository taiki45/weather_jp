[![Build Status](https://secure.travis-ci.org/Taiki45/weather_jp.png?branch=master)](http://travis-ci.org/Taiki45/weather_jp)

## About

Japan weather info API wrapper.

Fetch Japan weather info as Ruby object easily.

http://taiki45.github.com/weather_jp

https://rubygems.org/gems/weather_jp

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
tokyo = WeatherJp.get :tokyo
tokyo = WeatherJp.get "東京都府中市"
minato = WeatherJp::Weather.new("東京都港区")

# get weather info as String
tokyo.today.to_s
  #=> can be "東京都 東京の天気は曇りのち晴れ、最高気温34度...etc"

# to get weather info in differrnt ways
minato.get_weather(4) #=> <#DayWeather object>
minato.today.forecast #=> can be "晴れ"
tokyo.get_weather(:tomorrow).rain
minato.day_after_tomorrow.to_s
Weather.get(:tokyo, :today).forecast

# use Weather object
tokyo.each do |w|
  puts w.city_name
  puts w.day
  puts w.forecast
  puts w.max_temp
  puts w.min_temp
  puts w.rain
  w.each_pair {|k,v| puts k, v }
end

minato.map {|w| [w.day, w.forecast] }

# or use as simple Array or Hash
tokyo.to_a
minato.each {|w| p w.to_hash }

# you can cutomize DayWeather#to_s method
Weather.get(:tokyo).today.to_s #=> "東京 東京都の天気は晴れ....etc"

Weather.customize_to_s do
  word = "#{day}の#{city_name}は#{forecast} "
  word << "最高気温は#{max_temp} " if max_temp
  word << "最低気温は#{min_temp} " if min_temp
  word << "降水確率は#{rain}%" if rain
  word << "でし"
  word
end

Weather.get(:tokyo).today.to_s #=> "本日の東京 東京都は晴れ...."

```

## Requires

Ruby >= 1.9.2

## Documents

http://rubydoc.info/gems/weather_jp/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Feel free to any requests or bug reports, issues, comments.

Thank you :)

