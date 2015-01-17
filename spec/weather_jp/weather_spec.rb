require 'spec_helper'

RSpec.describe WeatherJp::Weather do
  include Fixturable
  set_fixture 'tokyo.xml'

  let(:weather) { WeatherJp.get(:tokyo) }

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


