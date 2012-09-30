# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Weather" do
  describe "with Internet connetion" do
    before(:all) do
      @weather = WeatherJp::Weather.new(:tokyo)
    end

    describe "#initialize" do
      it "should have @area_code and can access" do
        @weather.area_code.should == "JAXX0085"
      end

      it "should have @city_name and can access" do
        @weather.city_name.should == "東京都 東京"
      end

      it "should accept String argument" do
        weather = WeatherJp::Weather.new "東京都府中市"
        weather.city_name.should == "東京都 府中市"
      end

      it "should accept Symbol argument" do
        weather = WeatherJp::Weather.new :tokyo
        weather.city_name.should == "東京都 東京"
      end

      it "should have @day_weathers as Array" do
        @weather.day_weathers.class.should == Array
      end

      it "should have DayWeather instance in @day_weathers" do
        @weather.day_weathers.each do |w|
          w.class.should == WeatherJp::Weather::DayWeather
        end
      end

      it "should have 5 DayWeather instance in @day_weathers" do
        @weather.day_weathers.size.should == 5
      end
    end

    describe "#get_area_code" do
      it "should get vaild area code" do
        @weather.area_code.should == "JAXX0085"
      end

      it "should raise error when invaild city name taken" do
        WeatherJp::Weather.new(:aaa).city_name.should == "アメリカ合衆国 マイアミ"
      end
    end

    describe "#to_hash" do 
      it "should return Array and include Hashs" do
        @weather.to_hash.class.should == Array
        @weather.to_hash.each {|e| e.class.should == Hash }
      end

      it "should return with vaild structure" do
        @weather.to_hash.each do |e|
          e.should have_key(:day)
          e.should have_key(:forecast)
          e.should have_key(:max_temp)
          e.should have_key(:rain)
        end
      end
    end

    describe "#to_a" do
      it "should return and behavior same as #to_hash" do
        @weather.to_a.should equal(@weather.to_hash)
      end
    end

    describe "#each" do
      it "should yield DayWeather object" do
        @weather.each {|w| w.class.should == WeatherJp::Weather::DayWeather }
      end
    end

    describe "Enumerable mehods" do
      it "should respond to Enumerable methods" do
        @weather.should respond_to(:map)
      end

      it "should yield DayWeather Object" do
        @weather.map {|w| w.class.should == WeatherJp::Weather::DayWeather }
      end
    end

    describe "#get_weather" do
      it "should accept Symbol argument" do
        ->(){ @weather.get_weather(:today) }.
          should_not raise_error(ArgumentError)
        ->(){ @weather.get_weather(:tomorrow) }.
          should_not raise_error(ArgumentError)
      end

      it "should accept String argument" do
        ->(){ @weather.get_weather('today') }.
          should_not raise_error(ArgumentError)
        ->(){ @weather.get_weather('tomorrow') }.
          should_not raise_error(ArgumentError)
      end

      it "should accept 0 to 4 number as argument" do
        (0..4).each do |n|
          ->(){ @weather.get_weather(n) }.
            should_not raise_error(ArgumentError)
        end
      end

      it "should raise ArgumentError when got invaild aregument" do
        ->(){ @weather.get_weather(:yesterday) }.
          should raise_error(ArgumentError)
        ->(){ @weather.get_weather(5) }.
          should raise_error(ArgumentError)
      end

      it "should return DayWeather object" do
        @weather.get_weather(0).class.
          should == WeatherJp::Weather::DayWeather
      end
    end

    describe "#today, #tomorrow, #day_after_tomorrow" do
      it "should not error when call #today or something" do
        %w(today tomorrow day_after_tomorrow).each do |s|
          ->(){ @weather.send(s.to_sym) }.
            should_not raise_error(NoMethodError)
        end
      end

      it "should return DayWeather object" do
        %w(today tomorrow day_after_tomorrow).each do |s|
          @weather.send(s.to_sym).class.
            should == WeatherJp::Weather::DayWeather
        end
      end
    end
  end

  describe "with fixtures" do
    before(:all) do
      dummy = ''
      rss_one {|rss| dummy = RSS::Parser.parse rss }
      WeatherJp::Weather.class_exec dummy do |dummy|
        define_method(:get_area_code) {|city_name| ["JAXX0085", 'tokyo'] }
        define_method(:get_rss) { dummy }
      end
      @weather = WeatherJp::Weather.new(:tokyo)
    end

    describe "#set_weathers" do
      it "should have vaild data" do
        expect = [{:day=>"今日", :forecast=>"晴のち雨", :max_temp=>"29", :min_temp=>"24", :rain=>"80"},
          {:day=>"明日", :forecast=>"雨のち晴", :max_temp=>"30", :min_temp=>"22", :rain=>"60"},
          {:day=>"火曜日", :forecast=>"曇時々晴", :max_temp=>"27", :min_temp=>"22", :rain=>"30"},
          {:day=>"水曜日", :forecast=>"曇時々雨", :max_temp=>"25", :min_temp=>"20", :rain=>"50"},
          {:day=>"木曜日", :forecast=>"曇り", :max_temp=>"28", :min_temp=>"20", :rain=>"40"}
        ]
        @weather.to_hash.should == expect
      end
    end

    describe "#get_weather_data" do
      describe "#parse_rss" do
        it "should parse rss data" do
          expect = ["今日: 晴のち雨. 最低: 24&#176;C. 最高: 29&#176;C. 降水確率: 80", "明日: 雨のち晴. 最低: 22&#176;C. 最高: 30&#176;C. 降水確率: 60", "火曜日: 曇時々晴. 最低: 22&#176;C. 最高: 27&#176;C. 降水確率: 30", "水曜日: 曇時々雨. 最低: 20&#176;C. 最高: 25&#176;C. 降水確率: 50", "木曜日: 曇り. 最低: 20&#176;C. 最高: 28&#176;C. 降水確率: 40"]
          rss_one do |rss|
            @weather.send(:parse_rss, RSS::Parser.parse(rss)).should == expect
          end
        end
      end

      describe "#remove_html_tag" do
        it "should remove html tags" do
          data = %q(<html>a<a href="dummy">b</a><span>c</sapan></html>)
          @weather.send(:remove_html_tag, data).should == %(""a""b""""c"""")
        end
      end
    end
  end
end
