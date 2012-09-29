[![Build Status](https://secure.travis-ci.org/Taiki45/weather_jp.png?branch=master)](http://travis-ci.org/Taiki45/weather_jp)

## About

天気予報サービス API ラッパーです。

天気予報を簡単に Ruby オブジェクトにします。

http://taiki45.github.com/weather_jp

https://rubygems.org/gems/weather_jp

## インストール

この一行をあなたのアプリケーションの Gemfile に追記して下さい:

    gem 'weather_jp'

そしてこう実行します:

    $ bundle

または gem コマンドを使ってインストールします:

    $ gem install weather_jp

## 使い方

```ruby
# 全体の天気予報を扱うオブジェクトを作るいくつかの方法
tokyo = WeatherJp.get :tokyo
akiba = WeatherJp.get "秋葉原"
abuja = WeatherJp::Weather.new("アブジャ")
tsuyama = WeatherJp.get "津山"

# 天気予報を文字列として取得
tokyo.today.to_s
  #=> これは "東京都 東京の天気は曇りのち晴れ、最高気温34度...etc" になります

# Weather オブジェクトを取得するいくつかの方法
akiba.get_weather(4) #=> <#DayWeather object>
tokyo.today.forecast #=> can be "晴れ"
tokyo.get_weather(:tomorrow).rain
akiba.day_after_tomorrow.to_s
WeatherJp.get(:tokyo, :today).forecast

# Weather オブジェクトを使ってみる
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

# もしくは単純な Array や Hash として扱う方法
tokyo.to_a
tsuyama.each {|w| p w.to_hash }
akiba.day_weathers

# DayWeather#to_s メソッドをカスタマイズすることもできます
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

## 必要な環境

Ruby >= 1.9.2

## ドキュメント

http://rubydoc.info/gems/weather_jp/

## 作者

[@taiki45](https://twitter.com/taiki45)

## 貢献方法

1. Fork してください
2. あなたの機能を盛り込んだブランチを作って下さい (`git checkout -b my-new-feature`)
3. コミットしてください (`git commit -am 'Added some feature'`)
4. あなたの変更をプッシュしてください (`git push origin my-new-feature`)
5. Pull Request を作ってください

どんな要望やバグ報告、イッシュー、コメントも歓迎します

Thank you :)
