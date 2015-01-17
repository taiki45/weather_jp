require 'spec_helper'

RSpec.describe WeatherJp::DayWeather do
  include Fixturable
  set_fixture 'tokyo.xml'

  let(:weather) { WeatherJp.get(:tokyo) }
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
