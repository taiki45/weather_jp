require 'spec_helper'

describe 'Weather' do
  describe 'with Internet connetion' do
    let(:area_code) { 'JAXX0085' }
    let(:city_name) { 'tokyo' }
    let(:weathers) do
      [
        {:day=>'今日', :forecast=>'晴のち雨', :max_temp=>29, :min_temp=>24, :rain=>80},
        {:day=>'明日', :forecast=>'雨のち晴', :max_temp=>30, :min_temp=>22, :rain=>60},
        {:day=>'火曜日', :forecast=>'曇時々晴', :max_temp=>27, :min_temp=>22, :rain=>30},
        {:day=>'水曜日', :forecast=>'曇時々雨', :max_temp=>25, :min_temp=>20, :rain=>50}
      ]
    end

    before do
      @weather = WeatherJp::Weather.new(area_code, city_name, weathers)
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

      it 'should accept 0 to 2 number as argument' do
        (0..2).each do |n|
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
