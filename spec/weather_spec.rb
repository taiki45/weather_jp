# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'Weather' do
  describe 'with Internet connetion' do
    before(:all) do
      @weather = WeatherJp::Weather.new(:tokyo)
    end

    describe '#initialize' do
      it 'should have @area_code and can access' do
        expect(@weather.area_code).to eq('JAXX0085')
      end

      it 'should accept Symbol argument' do
        weather = WeatherJp::Weather.new :tokyo
        expect(weather.city_name).to eq('tokyo')
      end

      it 'should have @day_weathers as Array' do
        expect(@weather.day_weathers.class).to eq(Array)
      end

      it 'should have DayWeather instance in @day_weathers' do
        @weather.day_weathers.each do |w|
          expect(w.class).to eq(WeatherJp::Weather::DayWeather)
        end
      end

      it 'should have 5 DayWeather instance in @day_weathers' do
        expect(@weather.day_weathers.size).to eq(5)
      end
    end

    describe '#to_hash' do 
      it 'should return Array and include Hashs' do
        expect(@weather.to_hash.class).to eq(Array)
        @weather.to_hash.each {|e| expect(e.class).to eq(Hash) }
      end

      it 'should return with vaild structure' do
        @weather.to_hash.each do |e|
          expect(e).to have_key(:day)
          expect(e).to have_key(:forecast)
          expect(e).to have_key(:max_temp)
          expect(e).to have_key(:rain)
        end
      end
    end

    describe '#to_a' do
      it 'should return and behavior same as #to_hash' do
        expect(@weather.to_a).to equal(@weather.to_hash)
      end
    end

    describe '#each' do
      it 'should yield DayWeather object' do
        @weather.each {|w| expect(w.class).to eq(WeatherJp::Weather::DayWeather) }
      end
    end

    describe 'Enumerable mehods' do
      it 'should respond to Enumerable methods' do
        expect(@weather).to respond_to(:map)
      end

      it 'should yield DayWeather Object' do
        @weather.map {|w| expect(w.class).to eq(WeatherJp::Weather::DayWeather) }
      end
    end

    describe '#get_weather' do
      it 'should accept Symbol argument' do
        expect(){ @weather.get_weather(:today) }.
          not_to raise_error
        expect(){ @weather.get_weather(:tomorrow) }.
          not_to raise_error
      end

      it 'should accept String argument' do
        expect(){ @weather.get_weather('today') }.
          not_to raise_error
        expect(){ @weather.get_weather('tomorrow') }.
          not_to raise_error
      end

      it 'should accept 0 to 4 number as argument' do
        (0..4).each do |n|
          expect(){ @weather.get_weather(n) }.
            not_to raise_error
        end
      end

      it 'should raise WeatherJp::WeatherJpError when got invaild aregument' do
        expect(){ @weather.get_weather(:yesterday) }.
          to raise_error(WeatherJp::WeatherJpError)
        expect(){ @weather.get_weather(5) }.
          to raise_error(WeatherJp::WeatherJpError)
      end

      it 'should return DayWeather object' do
        expect(@weather.get_weather(0).class).
          to eq(WeatherJp::Weather::DayWeather)
      end
    end

    describe '#today, #tomorrow, #day_after_tomorrow' do
      it 'should not error when call #today or something' do
        %w(today tomorrow day_after_tomorrow).each do |s|
          expect(){ @weather.send(s.to_sym) }.
            not_to raise_error
        end
      end

      it 'should return DayWeather object' do
        %w(today tomorrow day_after_tomorrow).each do |s|
          expect(@weather.send(s.to_sym).class).
            to eq(WeatherJp::Weather::DayWeather)
        end
      end
    end
  end
end
