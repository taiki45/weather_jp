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

      it "should accept Symbol argument" do
        weather = WeatherJp::Weather.new :tokyo
        weather.city_name.should == "tokyo"
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
end
