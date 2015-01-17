# weather_jp [![Build Status](https://travis-ci.org/taiki45/weather_jp.svg?branch=master)](https://travis-ci.org/taiki45/weather_jp) [![Coverage Status](https://coveralls.io/repos/taiki45/weather_jp/badge.svg?branch=master)](https://coveralls.io/r/taiki45/weather_jp?branch=master) [![Code Climate](https://codeclimate.com/github/taiki45/weather_jp/badges/gpa.svg)](https://codeclimate.com/github/taiki45/weather_jp) [![Gem Version](https://badge.fury.io/rb/weather_jp.svg)](http://badge.fury.io/rb/weather_jp)
Japan weather infomation API wrapper. Fetch Japan weather status or forecast as Ruby object easily.

## V2 upgrade guides
The backend server returns differrnt contents from before. So V1 is not working. Please update to V2.

And V2 contains some of new features, deprecations and removales.

- `WeatherJp::City` now available. You can get latitude/longitude of the city.
- `WeatherJp::Weather#current`. The current weather is a little bit differrnt from day weather forecast.
  - have: `temperature`, `wind_speed`, `wind_text`
  - not have: `precip`, `high`, `low`.
- `WeatherJp::Weather#each` now contains the `DayWeather` object which represents current weather status. If you do not want current weather status, use `each_without_current` or `except_current` method.
- Remove `customize_to_s` method. This feature will be re-added as configurable procedure.
- Remove option from `WeatherJp.get`. If you use these option, use `WeatherJp::Weather#for`.

See deprecations at [API document page](http://rubydoc.info/gems/weather_jp/).

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
tsuyama = WeatherJp.get "津山"

# get weather info as String
tokyo.today.to_s
  #=> can be "東京都 東京の天気は曇りのち晴れ、最高気温34度...etc"

# or your have unparsed string
WeatherJp.parse("今日の香川県の天気教えて下さい").to_s
  #=> "香川県 高松の今日の天気は曇のち晴れ 最高気温25度 最低気温17度 降水確率は20% です。"

# to get weather info in differrnt ways
tokyo.today.text #=> can be "晴れ"
tokyo.tomorrow.precip #=> can be 10
akiba.day_after_tomorrow.to_s

# yields DayWeather object
tokyo.each do |w|
  puts w.city_name
  puts w.date
  puts w.date_text
  puts w.text
  puts w.high
  puts w.low
  puts w.precip
end

# You can use WeatherJp::City object
tokyo.city => WeatherJp::City
[tokyo.city.longitude, tokyo.city.latitude]

akiba.map {|w| [w.date_text, w.text] }

# or use as simple Array or Hash
tokyo.to_a
akiba.weathers
tsuyama.each {|w| p w.to_hash }
```

See more detail in [API document page](http://rubydoc.info/gems/weather_jp/).

## Requires

Ruby >= 2.0.0

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
