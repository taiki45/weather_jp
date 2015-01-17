# -*- coding: utf-8 -*-
require 'spec_helper'

describe "DayWeather" do
  before :all do
    @weather = WeatherJp.get(:tokyo, :today)
  end

  describe "#initialize" do
    it "should have @city_name" do
      expect(@weather.city_name).to eq("tokyo")
    end

    it "should have @weather as Hash" do
      expect(@weather.instance_variable_get(:@weather).class).
        to eq(Hash)
    end
  end

  describe "#inspect" do
    it "should return String" do
      expect(@weather.inspect.class).to eq(String)
    end

    it "should have certain format" do
      expect(@weather.inspect).to eq("#<DayWeather:@city_name = tokyo, @day=今日, @forecast=晴のち雨, @max_temp=29, @min_temp=24, @rain=80>")
    end
  end

  describe "#to_hash" do
    it "should return Hash" do
      expect(@weather.to_hash.class).to eq(Hash)
    end

    it "should be certain structure" do
      expect(@weather.to_hash).to have_key(:day)
      expect(@weather.to_hash).to have_key(:forecast)
      expect(@weather.to_hash).to have_key(:max_temp)
      expect(@weather.to_hash).to have_key(:rain)
    end
  end

  describe "#each" do
    it "should yield only value" do
      @weather.each {|v| expect(v.class).not_to eq(Array) }
      @weather.each do |v, n|
        expect(n).to eq(nil)
      end
    end

    it "should yield value" do
      expect(){ @weather.each {|v|} }.not_to raise_error
    end
  end

  describe "#each_pair" do
    it "should yield pair" do
      expect(){ @weather.each_pair {|k,v|} }.
        not_to raise_error
    end
  end

  describe "Enumerable#methods" do
    it "should not raise error when use Enumerable#mehod" do
      expect(){ @weather.map{|v| v } }.not_to raise_error
    end
  end
end

