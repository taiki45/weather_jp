require 'spec_helper'

RSpec.describe WeatherJp::City do
  include Fixturable
  set_fixture 'tokyo.xml'

  let(:weather) { WeatherJp.get(:tokyo) }
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
