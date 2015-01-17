# -*- coding: utf-8 -*-
require 'spec_helper'

describe "WeatherJp" do
  before :all do
    @weather = WeatherJp.get :tokyo
  end

  describe ".get" do
    it "should return Weather instance" do
      @weather.class.should == WeatherJp::Weather
    end

    it "should accept option and return DayWeather object" do
      WeatherJp.get(:tokyo, :today).class.
        should == WeatherJp::Weather::DayWeather
    end
  end

  describe ".customize_to_s" do
    it "should customize DayWeather#to_s" do
      WeatherJp.customize_to_s { 'success' }
      WeatherJp.get(:tokyo, :today).to_s.should == 'success'
    end
  end
end

