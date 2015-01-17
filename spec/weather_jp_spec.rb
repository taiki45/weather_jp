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
end
