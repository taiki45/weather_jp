require 'spec_helper'

RSpec.describe WeatherJp do
  include Fixturable
  set_fixture 'tokyo.xml'

  let(:weather) { WeatherJp.get(:tokyo) }

  describe '.get' do
    subject { described_class.get(:tokyo) }
    it { is_expected.to be_kind_of(WeatherJp::Weather) }
  end

  describe '.parse' do
    subject { described_class.parse('明日の東京の天気') }
    it { is_expected.to be_kind_of(WeatherJp::DayWeather) }
  end

  describe WeatherJp::Weather do
    describe '#each' do
      it 'succeeds' do
        expect { weather.each {} }.not_to raise_error
      end
    end

    describe '#each_without_current' do
      it 'succeeds' do
        expect { weather.each_without_current {} }.not_to raise_error
      end
    end

    describe '#current' do
      subject { weather.current }
      it { is_expected.to be_kind_of(WeatherJp::DayWeather) }
    end

    describe '#today' do
      subject { weather.today }
      it { is_expected.to be_kind_of(WeatherJp::DayWeather) }
    end

    describe '#tomorrow' do
      subject { weather.tomorrow }
      it { is_expected.to be_kind_of(WeatherJp::DayWeather) }
    end

    describe '#day_after_tomorrow' do
      subject { weather.day_after_tomorrow }
      it { is_expected.to be_kind_of(WeatherJp::DayWeather) }
    end

    describe '#for' do
      context 'with a Date' do
        subject { weather.for(Date.parse('2015-01-01')) }
        it 'is not implemented' do
          expect { subject }.to raise_error(NotImplementedError)
        end
      end
    end
  end

  describe WeatherJp::DayWeather do
    let(:day_weather) { weather.tomorrow }

    describe '#text' do
      subject { day_weather.text }
      it { is_expected.to eq('晴れ') }
    end

    describe '#high' do
      subject { day_weather.high }
      it { is_expected.to eq(52) }
    end

    describe '#low' do
      subject { day_weather.low }
      it { is_expected.to eq(34) }
    end

    describe '#precip' do
      subject { day_weather.precip }
      it { is_expected.to eq(0) }
    end

    describe '#date_text' do
      context 'with current' do
        let(:day_weather) { weather.current }
        subject { day_weather.date_text }
        it { is_expected.to eq('今') }
      end

      context 'with today' do
        let(:day_weather) { weather.today }
        subject { day_weather.date_text }
        it { is_expected.to eq('今日') }
      end

      context 'with tomorrow' do
        let(:day_weather) { weather.tomorrow }
        subject { day_weather.date_text }
        it { is_expected.to eq('明日') }
      end

      context 'with day after tomorrow' do
        let(:day_weather) { weather.day_after_tomorrow }
        subject { day_weather.date_text }
        it { is_expected.to eq('明後日') }
      end

      context 'with 3 days later' do
        let(:day_weather) { weather.for(3) }
        subject { day_weather.date_text }
        it { is_expected.to eq('3日後') }
      end
    end

    describe '#to_s' do
      subject { day_weather.to_s }
      it { is_expected.to match(/天気/) }
    end

    describe '#to_hash' do
      subject { day_weather.to_hash }
      it { is_expected.to be_kind_of(Hash) }
      it { is_expected.not_to be_empty }
    end

    context 'with current weather' do
      let(:day_weather) { weather.current }

      describe '#temperature' do
        subject { day_weather.temperature }
        it { is_expected.to eq(41) }
      end

      describe '#wind_speed' do
        subject { day_weather.wind_speed }
        it { is_expected.to eq(20) }
      end

      describe '#wind_text' do
        subject { day_weather.wind_text }
        it { is_expected.to eq('風向: 北北西 / 風速: 20 マイル') }
      end
    end
  end

  describe WeatherJp::City do
    let(:city) { weather.city }

    describe '#full_name' do
      subject { city.full_name }
      it { is_expected.to eq('東京都 東京') }
    end

    describe '#code' do
      subject { city.code }
      it { is_expected.to eq('JAXX0085') }
    end

    describe '#latitude' do
      subject { city.latitude }
      it { is_expected.to eq(35.6751957) }
    end

    describe '#longitude' do
      subject { city.longitude }
      it { is_expected.to eq(139.7695956) }
    end

    describe '#to_hash' do
      subject { city.to_hash }
      it { is_expected.to be_kind_of(Hash) }
      it { is_expected.not_to be_empty }
    end
  end
end
