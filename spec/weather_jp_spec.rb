# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'WeatherJp' do
  before :all do
    @weather = WeatherJp.get :tokyo
  end

  describe '.get' do
    it 'should return Weather instance' do
      expect(@weather.class).to eq(WeatherJp::Weather)
    end

    it 'should accept option and return DayWeather object' do
      expect(WeatherJp.get(:tokyo, :today).class).
        to eq(WeatherJp::Weather::DayWeather)
    end
  end

  describe '.customize_to_s' do
    it 'should customize DayWeather#to_s' do
      WeatherJp.customize_to_s { 'success' }
      expect(WeatherJp.get(:tokyo, :today).to_s).to eq('success')
    end
  end
end

