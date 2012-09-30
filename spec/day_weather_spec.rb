# -*- coding: utf-8 -*-
require 'spec_helper'

describe "DayWeather" do
  before(:all) do
    @tokyo = WeatherJp::Weather.new(:tokyo)
    @weather = @tokyo.get_weather(:today)
  end

  describe "#initialize" do
    it "should have @city_name" do
      @weather.city_name.should == "東京都 東京"
    end

    it "should have @weather as Hash" do
      @weather.instance_variable_get(:@weather).class.
        should == Hash
    end
  end

  describe "#inspect" do
    it "should return String" do
      @weather.inspect.class.should == String
    end
  end

  describe "#to_s" do
    it "should return String" do
      @weather.to_s.class.should == String
    end

    it "should be certain string format" do
      @weather.to_s.should =~ /東京都\s東京の今日の天気は.*\sです。/u
    end
  end

  describe "#to_hash" do
    it "should return Hash" do
      @weather.to_hash.class.should == Hash
    end

    it "should be certain structure" do
      @weather.to_hash.should have_key(:day)
      @weather.to_hash.should have_key(:forecast)
      @weather.to_hash.should have_key(:max_temp)
      @weather.to_hash.should have_key(:rain)
    end
  end

  describe "#each" do
    it "should yield only value" do
      @weather.each {|v| v.class.should_not == Array }
      @weather.each do |v, n|
        n.should == nil
      end
    end

    it "should yield value" do
      ->(){ @weather.each {|v|} }.should_not raise_error(Exception)
    end
  end

  describe "#each_pair" do
    it "should yield pair" do
      ->(){ @weather.each_pair {|k,v|} }.
        should_not raise_error(Exception)
    end
  end

  describe "Enumerable#methods" do
    it "should not raise error when use Enumerable#mehod" do
      ->(){ @weather.map{|v| v } }.should_not raise_error(NoMethodError)
    end
  end
end
