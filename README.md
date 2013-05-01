# weather_jp [![Build Status](https://secure.travis-ci.org/taiki45/weather_jp.png)](http://travis-ci.org/taiki45/weather_jp)
Japan weather info API wrapper.

Fetch Japan weather info as Ruby object easily.

http://taiki45.github.com/weather_jp

https://rubygems.org/gems/weather_jp

## Installation

Add this line to your application's Gemfile:

    gem 'weather_jp'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weather_jp

## Usage

```ruby
# creat weather object in differrnt ways
tokyo = WeatherJp.get :tokyo
akiba = WeatherJp.get "秋葉原"
abuja = WeatherJp::Weather.new("アブジャ")
tsuyama = WeatherJp.get "津山"

# get weather info as String
tokyo.today.to_s
  #=> can be "東京都 東京の天気は曇りのち晴れ、最高気温34度...etc"

# or your have unparsed string
WeatherJp.parse("今日のうどん県の天気教えて下され〜〜").to_s
  #=> "香川県 高松の今日の天気は曇のち晴れ 最高気温25度 最低気温17度 降水確率は20% です。"

# to get weather info in differrnt ways
akiba.get_weather(4) #=> <#DayWeather object>
tokyo.today.forecast #=> can be "晴れ"
tokyo.get_weather(:tomorrow).rain
akiba.day_after_tomorrow.to_s
WeatherJp.get(:tokyo, :today).forecast

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

akiba.map {|w| [w.day, w.forecast] }

# or use as simple Array or Hash
tokyo.to_a
tsuyama.each {|w| p w.to_hash }
akiba.day_weathers

# you can cutomize DayWeather#to_s method
WeatherJp.get(:tokyo).today.to_s #=> "東京 東京都の天気は晴れ....etc"

WeatherJp.customize_to_s do
  word = "#{day}の#{city_name}は#{forecast} "
  word << "最高気温は#{max_temp} " if max_temp
  word << "最低気温は#{min_temp} " if min_temp
  word << "降水確率は#{rain}%" if rain
  word << "でし"
  word
end

WeatherJp.get(:tokyo).today.to_s #=> "本日の東京 東京都は晴れ...."

```

## Requires

Ruby >= 1.9.2

## Documents

http://rubydoc.info/gems/weather_jp/

## Author

[@taiki45](http://taiki45.github.io/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Feel free to any requests or bug reports, issues, comments.

Thank you :)
