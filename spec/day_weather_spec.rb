# -*- coding: utf-8 -*-
require 'spec_helper'

describe "DayWeather" do
  before :all do
    @weather = WeatherJp.get(:tokyo, :today)
  end

  describe "#initialize" do
    it "should have @city_name" do
      @weather.city_name.should == "tokyo"
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

    it "should have certain format" do
      @weather.inspect.should == "#<DayWeather:@city_name = tokyo, @day=今日, @forecast=晴のち雨, @max_temp=29, @min_temp=24, @rain=80>"
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

